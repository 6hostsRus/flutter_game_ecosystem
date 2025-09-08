# AI Task Library Reconciliation (Open Items Only)

Generated: 2025-09-07

This reconciliation snapshot reflects the current open and partially-complete items. Completed tasks have been archived to `CHANGELOG.md` and removed from this file to keep the reconciliation focused and actionable.

## Legend

-    Status: Partial | Missing
-    Artifacts: Key scripts, workflows, docs, or tests that implement the task
-    Gaps/Next: Specific follow-ups to close gaps

## Current Partial / Open Items

| Task                     | Status  | Artifacts (current)                                                                               | Gaps / Next                                                               |
| ------------------------ | ------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| ExampleIntegrationUpdate | Partial | Demo app uses AppConfig flags; match demo updated with cascades; idle module has ECS stub + tests | Add idle ECS demo screen behind feature flag and document example README  |
| Small Snippets Backlog   | Partial | Remaining small snippet moves (platformer_player_controller, rpg_stats, ccg card serialization)   | Migrate each with a small test and README; close and archive in CHANGELOG |

## Next Tasks (concrete)

1. Migrate remaining snippet items with tests and minimal READMEs.
2. Add gated Idle demo screen to the example app and document how to enable it for local testing.
3. Implement a shared_preferences SaveDriver adapter as a follow-up (non-blocking).

If anything listed here has been completed and not yet archived to `CHANGELOG.md`, update the changelog and remove the row from this table. 4. Persistence adapters (follow-up) - Provide a basic shared_preferences SaveDriver adapter and tests; keep InMemory as default in tests
