# Monetization Testing

Updated: 2025-09-07

Scope: Test strategies for adapters, flows, and persistence.

Unit

-    Adapter mapping: statuses (pending/success/failure/cancelled/restored).
-    Cooldown & frequency logic (caps respected across sessions).
-    Deterministic fakes: expose flags to force outcomes and delays to test retries/timeouts.

Integration

-    Purchase persistence: wallet updates, save/load, negative paths.
-    Restore flows: idempotent and accurate reconciliation.
-    Sandbox/store configs: document steps to use Apple/Google sandbox testers for manual spot checks.

Golden/UI

-    Non-intrusive prompts; stable Keys; placement visibility rules reflected.

CI Hooks

-    Analytics minimum presence enforced.
-    Perf simulation thresholds validated.
-    Optional semantic parity artifacts for real plugin diffs.

Appendix

Sandbox checklist (manual):

-    Configure test users (App Store Connect/Play Console) and sign in on device.
-    Enable verbose logging for adapters during tests.
-    Validate: success, failure/cancel, restore; ensure events emitted and persisted.
