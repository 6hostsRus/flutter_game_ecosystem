# Analytics Event Naming

| Domain       | Event            | Description             | Key Props                                 |
| ------------ | ---------------- | ----------------------- | ----------------------------------------- |
| Monetization | purchase_success | Successful checkout     | sku, type, orderId, priceMicros, currency |
| Monetization | purchase_failed  | Failed checkout         | sku, reason                               |
| Economy      | economy_delta    | Currency balance change | currency, amount, reason, balance         |

## Conventions

-    Use `snake_case` for event names.
-    Include a stable `sku` or `currency` identifier where applicable.
-    Always include `reason` for economy deltas above a configurable threshold.
-    Avoid PII; user identifiers are handled as super/user properties by adapters.

## Adding New Events

1. Add instrumentation (onEvent hook or adapter wrapper).
2. Extend this table with domain, event, props.
3. Add/adjust a test in `packages/services/test/analytics/` verifying dispatch.
4. Ensure metrics updated (run `dart run tools/update_metrics.dart`).

## Test Logging

Analytics tests append NDJSON-like or map `toString()` lines to `build/metrics/analytics_events.ndjson` (both per-package and aggregated at root by `tools/run_all_tests.sh`). The metrics updater counts non-empty lines to produce `ANALYTICS_EVENTS`.
