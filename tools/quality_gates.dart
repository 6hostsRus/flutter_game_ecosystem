// Runs core quality gates: manifest completeness, coverage threshold, parity (optional).
// Provides a summary table and exits non-zero on failure.
import 'dart:io';

Future<int> _run(
  String label,
  List<String> cmd, {
  bool failOnNonZero = true,
  String? workingDir,
}) async {
  final proc = await Process.run(
    cmd.first,
    cmd.sublist(1),
    workingDirectory: workingDir,
    runInShell: true,
  );
  final code = proc.exitCode;
  stdout.writeln('> $label: exit=$code');
  if (proc.stdout is String && (proc.stdout as String).trim().isNotEmpty) {
    stdout.writeln(proc.stdout);
  }
  if (proc.stderr is String && (proc.stderr as String).trim().isNotEmpty) {
    stderr.writeln(proc.stderr);
  }
  if (failOnNonZero && code != 0) return code;
  return 0;
}

double _parseCoveragePct(File lcov) {
  int found = 0;
  int hit = 0;
  for (final l in lcov.readAsLinesSync()) {
    if (l.startsWith('DA:')) {
      found++;
      final parts = l.substring(3).split(',');
      if (parts.length == 2 && parts[1].trim() != '0') hit++;
    }
  }
  if (found == 0) return 0.0;
  return hit / found * 100.0;
}

void main() async {
  final rows = <Map<String, String>>[];
  bool allOk = true;

  // 1. Manifest completeness
  final manifestCode = await _run('manifest', [
    'dart',
    'run',
    'tools/check_manifest.dart',
  ]);
  rows.add({'Gate': 'Manifest', 'Result': manifestCode == 0 ? 'PASS' : 'FAIL'});
  if (manifestCode != 0) allOk = false;

  // 2. Parity (optional if already run separately). We'll run again for isolation.
  final parityCode = await _run('parity', [
    'dart',
    'run',
    'tools/check_stub_parity.dart',
  ]);
  rows.add({'Gate': 'Parity', 'Result': parityCode == 0 ? 'PASS' : 'FAIL'});
  if (parityCode != 0) allOk = false;

  // 3. Coverage threshold: read policy (tools/coverage_policy.yaml) if present.
  final covFile = File('coverage/lcov.info');
  double pct = 0.0; // computed later
  if (!covFile.existsSync()) {
    stderr.writeln('coverage/lcov.info missing (tests may not have been run)');
    allOk = false;
  } else {
    pct = _parseCoveragePct(covFile);
    double policyMin = 25.0;
    final policy = File('tools/coverage_policy.yaml');
    if (policy.existsSync()) {
      try {
        for (final l in policy.readAsLinesSync()) {
          final t = l.trim();
          if (t.startsWith('min_coverage_pct:')) {
            final v = t.split(':').last.trim();
            final parsed = double.tryParse(v);
            if (parsed != null) policyMin = parsed;
          }
        }
      } catch (_) {}
    }
    // Allow env override for experimentation.
    final min =
        double.tryParse(Platform.environment['COVERAGE_MIN'] ?? '') ??
        policyMin;
    final pass = pct >= min;
    rows.add({
      'Gate': 'Coverage >= ${min.toStringAsFixed(1)}%',
      'Result':
          pass
              ? 'PASS (${pct.toStringAsFixed(1)}%)'
              : 'FAIL (${pct.toStringAsFixed(1)}%)',
    });
    if (!pass) allOk = false;
  }

  // Summary table (markdown-style)
  stdout.writeln('\nQuality Gates Summary:');
  // 4. Analytics gate: ensure minimum analytics tests present.
  final analyticsDir = Directory('packages/services/test/analytics');
  if (analyticsDir.existsSync()) {
    final files =
        analyticsDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('_analytics_test.dart'))
            .toList();
    final pass = files.length >= 2;
    rows.add({
      'Gate': 'Analytics Tests >=2',
      'Result': pass ? 'PASS (${files.length})' : 'FAIL (${files.length})',
    });
    if (!pass) allOk = false;
  } else {
    rows.add({'Gate': 'Analytics Tests >=2', 'Result': 'FAIL (dir missing)'});
    allOk = false;
  }
  for (final r in rows) {
    stdout.writeln('- ${r['Gate']}: ${r['Result']}');
  }

  if (!allOk) {
    stderr.writeln('\nOne or more quality gates failed.');
    exit(1);
  }
  stdout.writeln('\nAll quality gates passed.');
}
