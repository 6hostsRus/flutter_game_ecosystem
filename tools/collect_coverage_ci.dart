#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';

/// Collect per-package coverage and merge into coverage/lcov.info.
///
/// Usage:
/// dart run tools/collect_coverage_ci.dart --ignore=examples/demo_game --ignore=packages/old
/// The script prints progress to stdout and emits a final line:
/// COVERAGE_MERGED=1  (or 0) which CI can parse into an output variable.

Future<void> main(List<String> args) async {
  final ignores = <String>[];
  for (final a in args) {
    if (a.startsWith('--ignore=')) {
      ignores.add(a.substring('--ignore='.length));
    }
  }

  final root = Directory.current;
  stdout.writeln('Collect coverage: repo root=${root.path}');

  final packageDirs = await _discoverPackages(root);
  if (packageDirs.isEmpty) {
    stderr.writeln('No packages discovered.');
    stdout.writeln('COVERAGE_MERGED=0');
    exit(0);
  }

  stdout.writeln('Discovered ${packageDirs.length} packages.');

  // track whether any coverage files were created (not strictly required)
  // but keep logic consistent.

  for (final dir in packageDirs) {
    final relPath = dir.path.replaceFirst(
      '${root.path}${Platform.pathSeparator}',
      '',
    );
    // honor ignore prefixes
    if (ignores.any((ig) => relPath.startsWith(ig))) {
      stdout.writeln('Skipping (ignored): $relPath');
      continue;
    }

    final testDir = Directory('${dir.path}${Platform.pathSeparator}test');
    if (!testDir.existsSync()) {
      stdout.writeln('No tests in: $relPath');
      continue;
    }

    stdout.writeln('Running coverage in: $relPath');
    final isFlutter = await _dependsOnFlutter(dir);
    final cmd = isFlutter ? 'flutter' : 'dart';
    final cmdArgs =
        isFlutter ? ['test', '--coverage'] : ['test', '--coverage=coverage'];

    final proc = await Process.start(
      cmd,
      cmdArgs,
      workingDirectory: dir.path,
      runInShell: true,
    );
    // stream output
    final outF = proc.stdout
        .transform(const SystemEncoding().decoder)
        .listen(stdout.write);
    final errF = proc.stderr
        .transform(const SystemEncoding().decoder)
        .listen(stderr.write);
    final code = await proc.exitCode;
    await outF.asFuture<void>();
    await errF.asFuture<void>();

    if (code != 0) {
      stderr.writeln('Tests exited with code $code in $relPath (continuing)');
    }

    // Check if this package produced a coverage file
    final covFile = File(
      '${dir.path}${Platform.pathSeparator}coverage${Platform.pathSeparator}lcov.info',
    );
    if (covFile.existsSync()) {
      stdout.writeln('Found coverage file for $relPath');
    }
  }

  // Find any per-package coverage file anywhere under repo
  final foundFiles = <File>[];
  await for (final ent in root.list(recursive: true, followLinks: false)) {
    if (ent is File &&
        ent.path.endsWith('coverage${Platform.pathSeparator}lcov.info')) {
      foundFiles.add(ent);
    }
  }

  if (foundFiles.isEmpty) {
    stdout.writeln('No per-package coverage files found. Skipping merge.');
    stdout.writeln('COVERAGE_MERGED=0');
    exit(0);
  }

  stdout.writeln('Merging ${foundFiles.length} coverage files...');
  final merge = await Process.run('dart', ['run', 'tools/merge_coverage.dart']);
  stdout.write(merge.stdout);
  stderr.write(merge.stderr);

  final merged = File(
    '${root.path}${Platform.pathSeparator}coverage${Platform.pathSeparator}lcov.info',
  );
  if (merged.existsSync()) {
    stdout.writeln('Merged coverage written to ${merged.path}');
    stdout.writeln('COVERAGE_MERGED=1');
    exit(0);
  } else {
    stdout.writeln('Merge did not produce coverage/lcov.info');
    stdout.writeln('COVERAGE_MERGED=0');
    exit(0);
  }
}

Future<List<Directory>> _discoverPackages(Directory root) async {
  final result = <Directory>[];
  final roots = [
    Directory('packages'),
    Directory('examples'),
    Directory('game_core'),
  ];
  for (final r in roots) {
    if (!r.existsSync()) continue;
    await for (final ent in r.list(recursive: true, followLinks: false)) {
      if (ent is File && ent.path.endsWith('pubspec.yaml')) {
        final dir = ent.parent;
        if (dir.path.contains(
          '${Platform.pathSeparator}build${Platform.pathSeparator}',
        ))
          continue;
        if (result.any((d) => d.path == dir.path)) continue;
        result.add(dir);
      }
    }
  }
  result.sort((a, b) => a.path.compareTo(b.path));
  return result;
}

Future<bool> _dependsOnFlutter(Directory dir) async {
  final pubspec = File('${dir.path}${Platform.pathSeparator}pubspec.yaml');
  if (!pubspec.existsSync()) return false;
  final txt = pubspec.readAsStringSync();
  return txt.contains('\nflutter:') || txt.contains('\n  flutter:');
}
