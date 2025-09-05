// change-class: infra
// RunQualityGateSuite
// Aggregates core quality gates and produces a pass/fail summary.
// Exits non-zero if any mandatory gate fails.
// Gates included:
//  - Stub Parity (tools/check_stub_parity.dart)
//  - Manifest Completeness (tools/check_manifest.dart)
//  - Coverage Threshold (tools/coverage_policy.yaml vs coverage/lcov.info)
//  - Route Spec Hash (strict) via tools/check_spec_hashes.dart --strict (if script exists)
//  - Analytics Tests Minimum (configurable env ANALYTICS_MIN_TESTS, default 1)
//  - Package Status Audit (non-blocking; warns only)
// Usage: dart run tools/run_quality_gates.dart
// Env:
//   ANALYTICS_MIN_TESTS=2  (example)
//   ALLOW_COVERAGE_MISSING=1  (do not fail if coverage file absent)
//   FAIL_ON_PACKAGE_STATUS=1  (treat package status warnings as failure)

import 'dart:io';

Future<void> main(List<String> args) async {
  final results = <_GateResult>[];

  results.add(
    await _runGate('StubParity', [
      'dart',
      'run',
      'tools/check_stub_parity.dart',
    ]),
  );
  results.add(
    await _runGate('Manifest', ['dart', 'run', 'tools/check_manifest.dart']),
  );
  results.add(await _coverageGate());
  results.add(await _routeSpecGate());
  results.add(await _analyticsTestsGate());
  results.add(await _packageStatusGate());

  final failCount = results.where((r) => r.failed).length;
  _printSummary(results);
  if (failCount > 0) {
    stderr.writeln('\nQUALITY GATES FAILED ($failCount)');
    exit(1);
  }
  stdout.writeln('\nAll mandatory quality gates passed.');
}

Future<_GateResult> _runGate(String name, List<String> command) async {
  final proc = await Process.run(command.first, command.sublist(1));
  final ok = proc.exitCode == 0;
  return _GateResult(
    name: name,
    failed: !ok,
    mandatory: true,
    details: _truncate(proc.stdout.toString()) + _stderrSuffix(proc.stderr),
  );
}

Future<_GateResult> _coverageGate() async {
  final policy = File('tools/coverage_policy.yaml');
  if (!policy.existsSync()) {
    return _GateResult(
      name: 'CoverageThreshold',
      failed: true,
      mandatory: true,
      details: 'Missing coverage_policy.yaml',
    );
  }
  double? minPct;
  for (final l in policy.readAsLinesSync()) {
    final t = l.trim();
    if (t.startsWith('min_coverage_pct:')) {
      minPct = double.tryParse(t.split(':').last.trim());
    }
  }
  if (minPct == null) {
    return _GateResult(
      name: 'CoverageThreshold',
      failed: true,
      mandatory: true,
      details: 'Could not parse min_coverage_pct',
    );
  }
  final lcov = File('coverage/lcov.info');
  if (!lcov.existsSync()) {
    final allow = Platform.environment['ALLOW_COVERAGE_MISSING'] == '1';
    return _GateResult(
      name: 'CoverageThreshold',
      failed: !allow,
      mandatory: !allow,
      details: 'coverage/lcov.info missing (allow=$allow)',
    );
  }
  final pct = _parseLcov(lcov.readAsLinesSync());
  final failed = pct < minPct;
  return _GateResult(
    name: 'CoverageThreshold',
    failed: failed,
    mandatory: true,
    details:
        'actual=${pct.toStringAsFixed(1)}% threshold=${minPct.toStringAsFixed(1)}%',
  );
}

Future<_GateResult> _routeSpecGate() async {
  final script = File('tools/check_spec_hashes.dart');
  if (!script.existsSync()) {
    return _GateResult(
      name: 'RouteSpecHash',
      failed: false,
      mandatory: false,
      details: 'Script missing (skipped)',
    );
  }
  final proc = await Process.run('dart', [
    'run',
    'tools/check_spec_hashes.dart',
    '--strict',
  ]);
  final ok = proc.exitCode == 0;
  return _GateResult(
    name: 'RouteSpecHash',
    failed: !ok,
    mandatory: true,
    details: _truncate(proc.stdout.toString()) + _stderrSuffix(proc.stderr),
  );
}

Future<_GateResult> _analyticsTestsGate() async {
  final min =
      int.tryParse(Platform.environment['ANALYTICS_MIN_TESTS'] ?? '') ?? 1;
  final testFiles = <String>[];
  final pkRoot = Directory('packages');
  if (pkRoot.existsSync()) {
    for (final e in pkRoot.listSync(recursive: true)) {
      if (e is File &&
          e.path.contains('/test/analytics/') &&
          e.path.endsWith('_analytics_test.dart')) {
        testFiles.add(e.path);
      }
    }
  }
  final failed = testFiles.length < min;
  return _GateResult(
    name: 'AnalyticsTestsCount',
    failed: failed,
    mandatory: true,
    details: 'found=${testFiles.length} required=$min',
  );
}

Future<_GateResult> _packageStatusGate() async {
  final script = File('tools/package_status_audit.dart');
  if (!script.existsSync()) {
    return _GateResult(
      name: 'PackageStatusAudit',
      failed: false,
      mandatory: false,
      details: 'No audit script',
    );
  }
  final proc = await Process.run('dart', [
    'run',
    'tools/package_status_audit.dart',
  ]);
  final output = proc.stdout.toString() + proc.stderr.toString();
  final warnings = RegExp(r'WARNING:').hasMatch(output);
  final treatFail = Platform.environment['FAIL_ON_PACKAGE_STATUS'] == '1';
  return _GateResult(
    name: 'PackageStatusAudit',
    failed: warnings && treatFail,
    mandatory: treatFail,
    details:
        warnings ? 'warnings present (treatFail=$treatFail)' : 'no warnings',
  );
}

void _printSummary(List<_GateResult> results) {
  stdout.writeln('\nQUALITY GATE SUMMARY');
  stdout.writeln('---------------------');
  for (final r in results) {
    final status = r.failed ? 'FAIL' : 'PASS';
    final mand = r.mandatory ? 'M' : 'O';
    stdout.writeln(
      '[${status.padRight(4)}][${mand}] ${r.name} :: ${r.details}',
    );
  }
}

String _truncate(String s, {int max = 400}) {
  final t = s.trim();
  if (t.length <= max) return t;
  return t.substring(0, max) + '...';
}

String _stderrSuffix(Object? err) {
  final e = err.toString().trim();
  if (e.isEmpty) return '';
  return (e.length > 120
      ? '\nERR:' + e.substring(0, 120) + '...'
      : '\nERR:' + e);
}

double _parseLcov(List<String> lines) {
  int found = 0;
  int hit = 0;
  for (final l in lines) {
    if (l.startsWith('DA:')) {
      found++;
      final parts = l.substring(3).split(',');
      if (parts.length == 2 && parts[1].trim() != '0') hit++;
    }
  }
  if (found == 0) return 0.0;
  return hit / found * 100.0;
}

class _GateResult {
  final String name;
  final bool failed;
  final bool mandatory;
  final String details;
  _GateResult({
    required this.name,
    required this.failed,
    required this.mandatory,
    required this.details,
  });
}
