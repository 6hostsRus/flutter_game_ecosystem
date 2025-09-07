# Analytics tests

This folder contains analytics-focused tests that emit newline-delimited JSON (NDJSON) for simple metrics and validation.

Helper

-    Use `appendAnalyticsNdjsonLine(String jsonLine)` from `package:services/analytics/testing.dart` to write test events.
-    The helper writes to both:
     -    `build/metrics/analytics_events.ndjson` (package-local)
     -    `../../build/metrics/analytics_events.ndjson` (repo root aggregation)

Conventions

-    One JSON object per line (no trailing commas).
-    Prefer `jsonEncode({...}) + '\n'` over map `toString()` for parseability.
-    Include `event` and (when available) `ts` in UTC ISO8601.
-    Avoid PII; keep props stable and machine-friendly.

Example

```dart
import 'dart:convert';
import 'package:services/analytics/testing.dart';

void logPurchaseSuccess() {
  appendAnalyticsNdjsonLine(jsonEncode({
    'event': 'purchase_success',
    'sku': 'pack.small',
    'ts': DateTime.now().toUtc().toIso8601String(),
  }) + '\n');
}
```

Run tests

```bash
cd /Users/Learn/Projects/flutter_game_ecosystem/packages/services
flutter test test/analytics -r expanded
```
