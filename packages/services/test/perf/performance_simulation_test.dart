import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:services/test_support/perf_harness.dart';

void main() {
  test('deterministic long-run simulation snapshot is stable', () {
    final h = PerfHarness(seed: 20250906);
    h.runTicks(500);
    final snap = h.snapshot();

    // Basic invariants
    expect(snap['ticks'], 500);
    expect((snap['wallet'] as Map)['premium'], 0);

    // Deterministic expectations for this seed and harness logic.
    // These values serve as a canary; update intentionally if harness changes.
    expect(snap['awards'], greaterThan(150));
    expect(snap['spends'], greaterThan(100));
    expect(snap['purchases'], greaterThan(50));

    // Write metrics artifact for CI dashboards.
    h.writeMetrics();
    expect(File('build/metrics/perf_simulation.json').existsSync(), isTrue);
  });
}
