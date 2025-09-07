# Monetization Testing

Updated: 2025-09-07

Scope: Test strategies for adapters, flows, and persistence.

Unit

-    Adapter mapping: statuses (pending/success/failure/cancelled/restored).
-    Cooldown & frequency logic (caps respected across sessions).

Integration

-    Purchase persistence: wallet updates, save/load, negative paths.
-    Restore flows: idempotent and accurate reconciliation.

Golden/UI

-    Non-intrusive prompts; stable Keys; placement visibility rules reflected.

CI Hooks

-    Analytics minimum presence enforced.
-    Perf simulation thresholds validated.
-    Optional semantic parity artifacts for real plugin diffs.
