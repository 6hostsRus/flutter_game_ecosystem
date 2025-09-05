// change-class: infra
// coverage_ratchet.dart
// Bumps the enforced coverage threshold (tools/coverage_policy.yaml)
// when the actual merged coverage exceeds the current threshold + 1.0%.
// Intended to be run after coverage generation (e.g., in CI post-test job).
//
// Policy:
// - Never lowers the threshold.
// - Bump granularity: 0.1% (one decimal place) to (actual - 0.1) floor.
// - Requires coverage/lcov.info to exist.
// - Writes updated last_updated timestamp (UTC ISO8601).
// - Exits 0 even if no bump (idempotent); non-zero only on IO / parse errors.

import 'dart:io';

Future<void> main() async {
  final policyFile = File('tools/coverage_policy.yaml');
  if (!policyFile.existsSync()) {
    stderr.writeln(
      'coverage_policy.yaml missing (expected at tools/coverage_policy.yaml)',
    );
    exit(1);
  }
  final lines = policyFile.readAsLinesSync();
  double? minPct;
  for (final l in lines) {
    final trimmed = l.trim();
    if (trimmed.startsWith('min_coverage_pct:')) {
      final v = trimmed.split(':').last.trim();
      minPct = double.tryParse(v);
    }
  }
  if (minPct == null) {
    stderr.writeln(
      'Failed to parse min_coverage_pct from coverage_policy.yaml',
    );
    exit(2);
  }
  final lcov = File('coverage/lcov.info');
  if (!lcov.existsSync()) {
    stdout.writeln('No coverage/lcov.info found; skipping ratchet.');
    return; // no failure; just skip
  }
  final actual = _parseCoveragePct(lcov.readAsLinesSync());
  stdout.writeln('Current threshold: ${minPct.toStringAsFixed(1)}%');
  stdout.writeln('Actual coverage : ${actual.toStringAsFixed(1)}%');
  final bumpNeeded = actual >= (minPct + 1.0);
  if (!bumpNeeded) {
    stdout.writeln(
      'No bump needed (need >= ${(minPct + 1.0).toStringAsFixed(1)}%).',
    );
    return;
  }
  // Compute new threshold (floor to 0.1 below actual to leave headroom).
  final newThreshold = _floorToTenths(actual - 0.1);
  if (newThreshold <= minPct) {
    stdout.writeln('Calculated new threshold not higher; skipping.');
    return;
  }
  final updated =
      lines.map((l) {
        if (l.trim().startsWith('min_coverage_pct:')) {
          return 'min_coverage_pct: ${newThreshold.toStringAsFixed(1)}';
        }
        if (l.trim().startsWith('last_updated:')) {
          return 'last_updated: ${DateTime.now().toUtc().toIso8601String()}';
        }
        return l;
      }).toList();
  policyFile.writeAsStringSync(updated.join('\n') + '\n');
  stdout.writeln(
    'Bumped coverage threshold to ${newThreshold.toStringAsFixed(1)}%.',
  );
}

double _parseCoveragePct(List<String> lines) {
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

double _floorToTenths(double value) {
  return (value * 10).floor() / 10.0;
}
