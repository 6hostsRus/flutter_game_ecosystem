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
| Small Snippets Backlog   | Done    | platformer_player_controller (modules/genres/game_scenes/src/platformer/player_controller.dart + tests), rpg_stats (modules/genres/rpg/src/stats.dart + tests), ccg card (modules/genres/ccg/lib/src/card.dart + tests), survivor run_state (modules/genres/survivor/src/run_state.dart + tests) | Archived: tests and READMEs added; no remaining small snippet migrations |

## Next Tasks (concrete)

1. Add gated Idle demo screen to the example app and document how to enable it for local testing.
2. Implement a shared_preferences SaveDriver adapter as a follow-up (non-blocking).

If anything listed here has been completed and not yet archived to `CHANGELOG.md`, update the changelog and remove the row from this table. 4. Persistence adapters (follow-up) - Provide a basic shared_preferences SaveDriver adapter and tests; keep InMemory as default in tests
