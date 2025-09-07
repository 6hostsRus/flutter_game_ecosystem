# AI Task Library Reconciliation (Open Items Only)

Snapshot mapping of open/partial tasks in `docs/AI_TASK_LIBRARY.md` to current repo state. Completed tasks are summarized in `CHANGELOG.md`.

Generated: 2025-09-06

## Legend

-    Status: Partial | Missing
-    Artifacts: Key scripts, workflows, docs, or tests that implement the task
-    Gaps/Next: Specific follow-ups to close gaps

## P2 — Strategic Hardening

| Task                                 | Status  | Artifacts                                                                                                 | Gaps / Next                                                                 |
| ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| SemanticParityCheckAgainstRealPlugin | Partial | tools/build_symbol_map.dart; tools/diff_parity_vs_real.dart; docs/SEMANTIC_PARITY.md; semantic-parity.yml | Consider gating on presence of real plugin; publish artifacts on PR trigger |

## Notes

-    For completed work prior to this date, see `CHANGELOG.md` under the matching date section.
