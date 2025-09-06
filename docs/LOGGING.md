# Logging & Event Conventions

Standardizing structured logs and analytics events improves debuggability, correlation, and automated validation.

## Goals

-    Human-scannable during local dev.
-    Machine-parseable (newline-delimited JSON for analytics/log export).
-    Stable keys for dashboards & anomaly detection.

## Log Levels

| Level | Use                                         | Example                            |
| ----- | ------------------------------------------- | ---------------------------------- |
| trace | High-frequency internals (disabled in prod) | frame_tick, economy_apply          |
| debug | Developer diagnostics                       | reward_granted, purchase_event_raw |
| info  | State transitions / business events         | purchase_success, economy_delta    |
| warn  | Recoverable issues needing attention        | wallet_retry, purchase_retry       |
| error | Failures impacting user path                | purchase_failed, db_write_error    |
| fatal | Unrecoverable, triggers crash/report        | init_panic                         |

## Base Fields

| Field  | Type           | Required | Description                             |
| ------ | -------------- | -------- | --------------------------------------- |
| ts     | ISO8601 string | yes      | Event timestamp (UTC)                   |
| level  | string         | yes      | Log level (trace..fatal)                |
| event  | string         | yes      | Event name (snake_case)                 |
| msg    | string         | rec      | Human readable summary                  |
| ctx    | object         | rec      | Contextual key/value pairs              |
| run_id | string         | rec      | Session/run correlation id (UUID)       |
| seq    | int            | rec      | Monotonic sequence per run for ordering |

## Analytics Event Naming

-    snake*case, domain prefix optional (economy*, purchase*, nav*)
-    Past-tense for results (purchase_success), present for continuous (session_start)
-    Avoid ambiguous verbs: prefer purchase_cancelled over purchase_cancel

## Reserved Prefixes

| Prefix     | Domain                                      |
| ---------- | ------------------------------------------- |
| economy\_  | Wallet & balances                           |
| purchase\_ | Monetization flows                          |
| nav\_      | Navigation / routing                        |
| perf\_     | Performance metrics                         |
| debug\_    | Temporary instrumentation (may be filtered) |

## File Logging (Tests)

-    Path: `build/metrics/analytics_events.ndjson`
-    Format: one JSON object per line (avoid trailing commas)
-    Tests should prefer `jsonEncode` over `toString()` maps to guarantee parseability.

Helper for tests:

-    Use `appendAnalyticsNdjsonLine(String jsonLine)` from `packages/services/lib/analytics/testing.dart`.
-    It writes to both package-local and repo-root NDJSON logs for metrics aggregation.

Example line:

```json
{
     "ts": "2025-09-05T04:55:00Z",
     "event": "purchase_success",
     "sku": "coins_100",
     "order_id": "abc123"
}
```

## Adapters & Hooks

-    Adapters emitting analytics should sanitize sensitive fields (no PII, tokens).
-    Economy deltas: event=economy_delta, fields: {currency, delta, balance_after, source?}
-    Purchase results: purchase_success / purchase_failed (include {sku, order_id?, error_code?})

## Correlation Strategy

-    Generate a `run_id` at app start; inject via provider to analytics sink.
-    Increment `seq` for every event to permit ordering across threads.

## Validation (Future Tasks)

-    Add test ensuring every emitted event line parses as JSON.
-    Gate CI if unknown prefix used.
-    Maintain event taxonomy doc (`docs/analytics_events.md`) -> cross-check.

## Migration Notes

-    Legacy map `toString()` lines will be phased out; new tests should adopt structured JSON immediately.

---

Generated via AI task: LoggingConventionsDoc (P1).
