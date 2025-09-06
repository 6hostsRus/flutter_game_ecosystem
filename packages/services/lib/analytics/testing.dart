// Utilities to standardize writing analytics events to NDJSON during tests.
// Intentionally dependency-light: no external packages.

library services.analytics.testing;

import 'dart:io';

/// Append a JSON line to per-package and repo-root NDJSON logs.
/// Paths:
///  - package-local: build/metrics/analytics_events.ndjson
///  - repo-root:     ../../build/metrics/analytics_events.ndjson
void appendAnalyticsNdjsonLine(String jsonLine) {
  final out = File('build/metrics/analytics_events.ndjson');
  final root = File('../../build/metrics/analytics_events.ndjson');
  out.parent.createSync(recursive: true);
  root.parent.createSync(recursive: true);
  out.writeAsStringSync(jsonLine, mode: FileMode.append);
  root.writeAsStringSync(jsonLine, mode: FileMode.append);
}
