# Test Support Helpers

Utilities intended for tests and deterministic simulations.

## Perf Harness

-    File: `perf_harness.dart`
-    Provides a deterministic economy + wallet simulation with seeded RNG.
-    Exposes `runTicks(count)`, `snapshot()`, and `writeMetrics()` which writes `build/metrics/perf_simulation.json` for CI dashboards.

## Transactions

-    File: `transactions.dart`
-    `transactionalSpend({ economy, currency, amount, adapter })` performs a spend and persists via `EconomyProfileAdapter`. If persistence fails, it rolls back the spend to the prior balance and rethrows.
-    Intended usage: wrap persistence after mutations in tests to assert rollback behavior on injected failures.

Conventions

-    Keep helpers deterministic and side-effect free (writing only under `build/` for artifacts).
-    Prefer small, composable helpers over complex test frameworks.
