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

| Task                               | Status  | Artifacts (current)                                                                                                                 | Gaps / Next                                                                          |
| ---------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| TemplatesAndSchemasRefactor        | Done    | packages/game_core/assets/schemas/_.schema.json; packages/game_core/lib/schemas/validator.dart; CLI default; docs/templates/_ moved | Monitor adoption; expand samples as needed                                           |
| SnippetsReconciliationToGameCore   | Partial | snippets/MIGRATION.md pre-populated with destinations                                                                               | Execute migrations with tests; update exports and docs                               |
| GameCoreRelocationAndConsolidation | Done    | packages/game_core/ in melos; imports audited; legacy removed; docs updated                                                         | Ensure all downstream references stay clean; add note to CHANGELOG                   |
| GameCoreInterfacesImplementation   | Planned | —                                                                                                                                   | Implement initial contracts + tests; export via `lib/game_core.dart`                 |
| DocsAndOpsAlignmentForMoves        | Partial | .github/labeler.yml updated; tools/schema_validator default path updated                                                            | Review workflow path filters (ci, metrics, golden-guard) for packages/game_core/\*\* |
| ExampleIntegrationUpdate           | Planned | —                                                                                                                                   | Update examples/genre modules to use new APIs and migrated utilities                 |
