# AI Task Library Reconciliation (Open Items Only)

Snapshot mapping of open/partial tasks in `docs/AI_TASK_LIBRARY.md` to current repo state. Completed tasks are summarized in `CHANGELOG.md`.

Generated: 2025-09-07

## Legend

-    Status: Partial | Missing
-    Artifacts: Key scripts, workflows, docs, or tests that implement the task
-    Gaps/Next: Specific follow-ups to close gaps

## P1 — Docs & CI Structure

| Task                                | Status  | Artifacts (expected)                                                                             | Gaps / Next                                                                |
| ----------------------------------- | ------- | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| ArchitectureStandardsReconciliation | Done    | docs/CODING_STANDARDS.md; links from ai_instructions.md and docs/WORKFLOWS.md; checklist updated | Evaluation checklist referenced in `docs/AI_TASK_CHECKLIST.md`             |
| MonetizationDocsReconciliation      | Missing | docs/monetization/overview.md; docs/monetization/testing.md; updated AI tasks for monetization   | Identify gaps from `monetization/monetization.md`; add concrete follow-ups |
| PlatformDocsMigration               | Done    | docs/platform/index.md (+ migrated topics); stubs under `platform/`                              | Verify cross-links in README/ai_instructions (minor follow-up)             |
| PlatformReleaseCIIntegration        | Done    | .github/workflows/platform-release.yml; docs/platform/release.md; entry in docs/WORKFLOWS.md     | Future: refine tracks, signing, lanes                                      |
| RoadmapMigrationAndPacingDoc        | Missing | docs/roadmap/phase-1.md (pacing & metrics); links from README and ai_instructions                | Migrate `roadmap/phase-1.md`; add goals, metrics, and references           |
| OpsDocsReconciliation               | Partial | docs/automation/index.md (canonical), root stubs for QUICK_OPS.md & secrets.example.md           | Mirror secret names (done); align README/ai_instructions links (follow-up) |

## P2 — Strategic Hardening

| Task                                 | Status  | Artifacts                                                                                                 | Gaps / Next                                                                 |
| ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| SemanticParityCheckAgainstRealPlugin | Partial | tools/build_symbol_map.dart; tools/diff_parity_vs_real.dart; docs/SEMANTIC_PARITY.md; semantic-parity.yml | Consider gating on presence of real plugin; publish artifacts on PR trigger |

## Notes

-    For completed work prior to this date, see `CHANGELOG.md` under the matching date section.
