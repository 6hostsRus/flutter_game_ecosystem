# AI Task Library Reconciliation (Open Items Only)

Snapshot mapping of open/partial tasks in `docs/AI_TASK_LIBRARY.md` to current repo state. Completed tasks are summarized in `CHANGELOG.md`.

Generated: 2025-09-07

## Legend

-    Status: Partial | Missing
-    Artifacts: Key scripts, workflows, docs, or tests that implement the task
-    Gaps/Next: Specific follow-ups to close gaps

## P1 — Docs & CI Structure

| Task                                | Status | Artifacts (expected)                                                                             | Gaps / Next                                                    |
| ----------------------------------- | ------ | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------- |
| ArchitectureStandardsReconciliation | Done   | docs/CODING_STANDARDS.md; links from ai_instructions.md and docs/WORKFLOWS.md; checklist updated | Evaluation checklist referenced in `docs/AI_TASK_CHECKLIST.md` |
| MonetizationDocsReconciliation      | Done   | docs/monetization/overview.md; docs/monetization/testing.md (gaps & sandbox checklist added)     | Monitor if additional adapter-specific docs are needed         |
| PlatformDocsMigration               | Done   | docs/platform/index.md (+ migrated topics); stubs under `platform/`                              | Verify cross-links in README/ai_instructions (minor follow-up) |
| PlatformReleaseCIIntegration        | Done   | .github/workflows/platform-release.yml; docs/platform/release.md; entry in docs/WORKFLOWS.md     | Future: refine tracks, signing, lanes                          |
| RoadmapMigrationAndPacingDoc        | Done   | docs/roadmap/phase-1.md (includes Pacing & Metrics, thresholds, cadence)                         | Cross-links will evolve as workflows grow (no action needed)   |
| OpsDocsReconciliation               | Done   | docs/automation/index.md (canonical); README and ai_instructions link to Ops doc                 | Optional: remove legacy stubs after one release cycle          |

## P2 — Strategic Hardening

| Task                                 | Status | Artifacts                                                                                                 | Gaps / Next                                                                 |
| ------------------------------------ | ------ | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| SemanticParityCheckAgainstRealPlugin | Done   | tools/build_symbol_map.dart; tools/diff_parity_vs_real.dart; docs/SEMANTIC_PARITY.md; semantic-parity.yml | Matrix across specs; PR label/manual trigger; PR summary comment; artifacts |

## Notes

-    For completed work prior to this date, see `CHANGELOG.md` under the matching date section.

## New Batch — Core consolidation and schemas

| Task                               | Status  | Artifacts (current)                                                                                                                 | Gaps / Next                                                                                      |
| ---------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| TemplatesAndSchemasRefactor        | Done    | packages/game*core/assets/schemas/*.schema.json; packages/game*core/lib/schemas/validator.dart; CLI default; docs/templates/* moved | Monitor adoption; expand samples as needed                                                       |
| SnippetsReconciliationToGameCore   | Done    | snippets replaced with pointers; migrated: platformer_player_controller, rpg_stats, match_board, ccg/card, survivor_run_state       | None                                                                                             |
| GameCoreRelocationAndConsolidation | Done    | packages/game_core/ in melos; imports audited; legacy removed; docs updated                                                         | Ensure all downstream references stay clean; add note to CHANGELOG                               |
| GameCoreInterfacesImplementation   | Done    | packages/game_core/lib/core/{clock,logger,rng,save_driver}.dart (+ tests); exports via game_core.dart                               | Consider persistence adapters in follow-ups (e.g., shared_prefs, file, isar)                     |
| DocsAndOpsAlignmentForMoves        | Done    | labeler updated for schemas/tooling; README + WORKFLOWS + templates cross-link schema validation; CI step documented                | None                                                                                             |
| ExampleIntegrationUpdate           | Partial | Demo app uses AppConfig flags; match demo gated by env flags; survivor HUD demo wired; idle module has ECS stub + tests             | Add idle ECS demo screen behind feature flag (to be implemented) and a short example README note |

## Next Tasks (concrete)

1. Snippets migration — remaining items (with tests)

     - platformer_player_controller → modules/genres/game_scenes (or platformer module) with Flame input adapter and a tiny test
     - rpg_stats → modules/genres/rpg with simple balance model + tests
     - match_board → modules/genres/match with deterministic RNG and a solver sanity test
     - ccg/card → modules/genres/ccg with model + serialization test
     - survivor_run_state → modules/genres/survivor with basic state machine + tick contract

2. Example wiring

     - Add an optional demo screen that spins IdleIncomeSystem over time and displays accumulating currency; guard with AppConfig.featureIdle

3. Docs & Ops alignment

     - If CI workflows are present, ensure path filters include packages/game_core/** and modules/genres/**
     - Add short note in CHANGELOG for the completed migrations and new modules

4. Persistence adapters (follow-up)
     - Provide a basic shared_preferences SaveDriver adapter and tests; keep InMemory as default in tests
