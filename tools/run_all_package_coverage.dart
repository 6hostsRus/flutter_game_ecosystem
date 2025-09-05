// change-class: infra
// RunAllPackagesCoverage script
// Discovers all package directories (with pubspec.yaml) and runs tests with coverage.
// Then aggregates per-package lcov.info files into root coverage/lcov.info (merged without duplication).
// Finally invokes update_metrics.dart so coverage markers & badge update.
// Usage: dart run tools/run_all_package_coverage.dart
// Options:
//   --skip-metrics   Do not run update_metrics at the end.
//   --verbose        Stream all test output (default streams failures only summary lines).

import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final verbose = args.contains('--verbose');
  final skipMetrics = args.contains('--skip-metrics');

  final packageDirs = await _discoverPackages();
  if (packageDirs.isEmpty) {
    stderr.writeln('No packages discovered.');
    exit(1);
  }
  stdout.writeln('Discovered ${packageDirs.length} packages:');
  for (final p in packageDirs) {
    stdout.writeln(' - ${p.path}');
  }

  final failures = <String>[];
  for (final dir in packageDirs) {
    stdout.writeln('\n[RUN] ${dir.path}');
    final isFlutter = await _dependsOnFlutter(dir);
    final covDir = Directory('${dir.path}/coverage');
    if (covDir.existsSync()) {
      try {
        covDir.deleteSync(recursive: true);
      } catch (_) {}
    }
    final cmd = isFlutter ? 'flutter' : 'dart';
    final args = isFlutter ? ['test', '--coverage'] : ['test'];
    final proc = await Process.start(
      cmd,
      args,
      workingDirectory: dir.path,
      runInShell: true,
    );
    final buffer = StringBuffer();
    final completers = <Future>[];
    completers.add(
      proc.stdout.transform(utf8.decoder).listen((d) {
        if (verbose)
          stdout.write(d);
        else
          buffer.write(d);
      }).asFuture(),
    );
    completers.add(
      proc.stderr.transform(utf8.decoder).listen((d) {
        if (verbose)
          stderr.write(d);
        else
          buffer.write(d);
      }).asFuture(),
    );
    final code = await proc.exitCode;
    await Future.wait(completers);
    if (code != 0) {
      failures.add(dir.path);
      if (!verbose) {
        stdout.writeln('--- Captured Output (${dir.path}) ---');
        stdout.writeln(buffer.toString());
        stdout.writeln('--- End Output ---');
      }
    }
    if (!covDir.existsSync()) {
      // For pure Dart packages we didn't collect coverage; attempt manual if dart.
      if (!isFlutter) {
        await _generateDartCoverage(dir, verbose: verbose);
      }
    }
  }

  if (failures.isNotEmpty) {
    stderr.writeln('Test failures in ${failures.length} packages:');
    for (final f in failures) {
      stderr.writeln(' - $f');
    }
    // Intentionally continue to aggregate coverage from successful packages.
  }

  await _aggregateCoverage(packageDirs);

  if (!skipMetrics) {
    stdout.writeln('\nRunning metrics update...');
    final r = await Process.run('dart', ['run', 'tools/update_metrics.dart']);
    if (r.exitCode != 0) {
      stderr.writeln('Metrics update failed:');
      stderr.writeln(r.stdout);
      stderr.writeln(r.stderr);
    } else {
      stdout.writeln('Metrics updated.');
    }
  }

  if (failures.isNotEmpty) exit(1);
}

Future<List<Directory>> _discoverPackages() async {
  final result = <Directory>[];
  // Directories to scan for pubspecs.
  final roots = [
    Directory('packages'),
    Directory('examples'),
    Directory('game_core'),
  ];
  for (final root in roots) {
    if (!root.existsSync()) continue;
    await for (final ent in root.list(recursive: true, followLinks: false)) {
      if (ent is File && ent.path.endsWith('pubspec.yaml')) {
        final dir = ent.parent;
        // Skip build/example nested test outputs, etc.
        if (dir.path.contains('/build/')) continue;
        // Avoid duplicate entries.
        if (result.any((d) => d.path == dir.path)) continue;
        // Skip root example groups w/o tests if desired (keep all for now).
        result.add(dir);
      }
    }
  }
  // Ensure deterministic order.
  result.sort((a, b) => a.path.compareTo(b.path));
  return result;
}

Future<bool> _dependsOnFlutter(Directory dir) async {
  final pubspec = File('${dir.path}/pubspec.yaml');
  if (!pubspec.existsSync()) return false;
  final txt = pubspec.readAsStringSync();
  return RegExp(
        r'^dependencies:\s*([\s\S]*?)^\w',
        multiLine: true,
      ).firstMatch(txt)?.group(1)?.contains('flutter:') ??
      txt.contains('\nflutter:');
}

Future<void> _generateDartCoverage(
  Directory dir, {
  bool verbose = false,
}) async {
  // Use dart test --coverage then format_coverage to LCOV if tooling present.
  final coverageDir = Directory('${dir.path}/coverage');
  coverageDir.createSync(recursive: true);
  stdout.writeln('[COV] Generating Dart coverage for ${dir.path}');
  final proc = await Process.start(
    'dart',
    ['test', '--coverage=coverage'],
    workingDirectory: dir.path,
    runInShell: true,
  );
  if (verbose) {
    await stdout.addStream(proc.stdout);
    await stderr.addStream(proc.stderr);
  } else {
    await proc.stdout.drain();
    await proc.stderr.drain();
  }
  final code = await proc.exitCode;
  if (code != 0) {
    stderr.writeln('dart test failed for ${dir.path} (code=$code)');
    return;
  }
  // Try to translate to lcov if package:coverage tool available.
  final packagesFile = File('${dir.path}/.dart_tool/package_config.json');
  final toolAvailable =
      packagesFile.existsSync() &&
      packagesFile.readAsStringSync().contains('coverage');
  if (toolAvailable) {
    final format = await Process.run('dart', [
      'run',
      'coverage:format_coverage',
      '--lcov',
      '--in=coverage',
      '--out=coverage/lcov.info',
      '--packages=.dart_tool/package_config.json',
      '--report-on=lib',
    ], workingDirectory: dir.path);
    if (format.exitCode != 0) {
      stderr.writeln(
        'format_coverage failed for ${dir.path}: ${format.stderr}',
      );
    }
  } else {
    // Fallback: create minimal lcov with placeholder (to avoid breaking).
    final f = File('${dir.path}/coverage/lcov.info');
    f.writeAsStringSync('TN:\nend_of_record\n');
  }
}

Future<void> _aggregateCoverage(List<Directory> packageDirs) async {
  stdout.writeln('\nAggregating coverage...');
  final fileLineHits = <String, Map<int, int>>{};

  for (final dir in packageDirs) {
    final f = File('${dir.path}/coverage/lcov.info');
    if (!f.existsSync()) continue;
    String? currentFile;
    for (final line in f.readAsLinesSync()) {
      if (line.startsWith('SF:')) {
        currentFile = line.substring(3).trim();
        fileLineHits.putIfAbsent(currentFile, () => <int, int>{});
      } else if (line.startsWith('DA:')) {
        final parts = line.substring(3).split(',');
        if (parts.length == 2 && currentFile != null) {
          final ln = int.tryParse(parts[0]);
          final hits = int.tryParse(parts[1]);
          if (ln != null && hits != null) {
            final map = fileLineHits[currentFile]!;
            final prev = map[ln] ?? 0;
            map[ln] = hits > prev ? hits : prev; // max
          }
        }
      }
    }
  }

  if (fileLineHits.isEmpty) {
    stderr.writeln('No coverage data collected.');
    return;
  }

  final rootCovDir = Directory('coverage');
  rootCovDir.createSync(recursive: true);
  final out = File('coverage/lcov.info');
  final sink = out.openWrite();
  final sortedFiles = fileLineHits.keys.toList()..sort();
  for (final file in sortedFiles) {
    final lines = fileLineHits[file]!;
    final lineNumbers = lines.keys.toList()..sort();
    final found = lineNumbers.length;
    final hit = lineNumbers.where((l) => (lines[l] ?? 0) > 0).length;
    sink.writeln('TN:');
    sink.writeln('SF:$file');
    for (final ln in lineNumbers) {
      sink.writeln('DA:$ln,${lines[ln]}');
    }
    sink.writeln('LH:$hit');
    sink.writeln('LF:$found');
    sink.writeln('end_of_record');
  }
  await sink.close();
  stdout.writeln(
    'Aggregated coverage written to coverage/lcov.info (files=${sortedFiles.length}).',
  );
}
