# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

# Open Tasks (current)

This file contains the actionable tasks that are still open or partially complete. Completed tasks have been archived to `CHANGELOG.md` and are no longer listed here.

Before running any task, follow the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.

---

## ExampleIntegrationUpdate (P2) — Partial

Purpose: Update `examples/demo_game` and genre modules to use new `game_core` APIs and any migrated snippets. Some demo wiring remains gated by feature flags and documentation updates.

Steps:

1. Replace old imports/usages with new `game_core` interfaces and utilities in the example and genre modules.
2. Ensure scenes build and run; adjust providers/services wiring if needed.
3. Add a short README note in the example about the new APIs and feature flags.

Validation:

-    `melos run example` runs without regressions.
-    Basic gameplay loop and save/ads/analytics hooks still function.

---

## Next Tasks (backlog)

These are smaller follow-ups that remain after the large consolidation work:

-    Snippets migration remaining items: platformer_player_controller, rpg_stats, ccg/card serialization, survivor_run_state follow-ups (each should include a test and tiny README).
-    Example wiring: add optional Idle demo screen behind AppConfig feature flag and document it in the example README.
-    Persistence adapters: implement a shared_preferences SaveDriver adapter with tests; keep InMemory for unit tests.

---

For previously completed work and the full archive of reconciled tasks see `CHANGELOG.md`.
