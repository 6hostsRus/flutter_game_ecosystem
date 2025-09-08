# Snippets Migration Plan

Purpose: Reconcile `snippets/dart/**` by migrating reusable code to `packages/game_core` or genre modules, and moving doc-only content into `docs/`.

Scope

-    Source folders:
     -    `snippets/dart/ccg` (card-collecting battle)
     -    `snippets/dart/core`
     -    `snippets/dart/idle`
     -    `snippets/dart/match`
     -    `snippets/dart/platformer`
     -    `snippets/dart/rpg`
     -    `snippets/dart/survivor`

Classification rubric

-    Core utility/extension reusable across games → Move to `packages/game_core` (with tests and exports).
-    Genre-specific gameplay example → Move to `modules/genres/<genre>/` (ensure it compiles; add brief README).
-    Doc-only or pseudocode → Move to `docs/snippets/<topic>.md` with explanation and links.

Process

1. Inventory and classify each file. Track status in the table below.
2. For code migrations:
     - Add unit tests (happy + one edge), follow `docs/CODING_STANDARDS.md`.
     - Add exports to `packages/game_core/lib/game_core.dart` (for core utilities) or relevant module exports.
     - Delete or replace original snippet with a pointer comment and update this table.
3. Update references in templates/docs.
     - Template design docs have moved to `docs/templates/`.

Status tracker

| Path                                                       | Class         | Destination                       | PR  | Notes                                           |
| ---------------------------------------------------------- | ------------- | --------------------------------- | --- | ----------------------------------------------- |
| snippets/dart/core/analytics_events.dart                   | Core utility  | packages/game_core/lib/telemetry/ | ✅  | Migrated as canonical AnalyticsEvents           |
| snippets/dart/core/app_config.dart                         | Core utility  | packages/game_core/lib/config/    | ✅  | Migrated as AppConfig with overrides            |
| snippets/dart/core/category_registry.dart                  | Core utility  | packages/game_core/lib/content/   | ✅  | Migrated as generic registry (no AppConfig)     |
| snippets/dart/platformer/platformer_player_controller.dart | Genre example | modules/genres/game_scenes/lib/   | ✅  | PlayerController moved; input adapter via tests |
| snippets/dart/rpg/rpg_stats.dart                           | Genre example | modules/genres/rpg/lib/           | ✅  | Stats model + serialization + tests             |
| snippets/dart/idle/idle_models.dart                        | Genre example | modules/genres/idle/lib/          | ✅  | Basic models + tests; ECS later                 |
| snippets/dart/idle/idle_time_service.dart                  | Core service  | packages/game_core/lib/time/      | ✅  | Migrated with Clock injection + tests           |
| snippets/dart/match/match_board.dart                       | Genre example | modules/genres/match/lib/         | ✅  | Deterministic RNG; tests for swap/clear/gravity |
| snippets/dart/ccg/card.dart                                | Genre example | modules/genres/ccg/lib/           |     | Card model + serialization                      |
| snippets/dart/survivor/survivor_run_state.dart             | Genre example | modules/genres/survivor/lib/      |     | State machine; ensure tick/update contract      |

Done criteria

-    Snippets directory reduced to pointers or doc-only files.
-    Migrated code is covered by tests and exported from game_core or the appropriate module.
-    Templates/docs updated to reference new locations.
