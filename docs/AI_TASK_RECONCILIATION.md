# AI Task Library Reconciliation

Snapshot mapping of tasks in `docs/AI_TASK_LIBRARY.md` to current repo state. Focus: what’s done, what’s partial/missing, and the concrete artifacts backing each item.

Generated: 2025-09-06

## Legend

-    Status: Done | Partial | Missing
-    Artifacts: Key scripts, workflows, docs, or tests that implement the task
-    Gaps/Next: Specific follow-ups to close gaps

## P0 — Reliability & Drift

| Task                                  | Status | Artifacts                                                                                                        | Gaps / Next                                                            |
| ------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| ExpandManifestFull                    | Done   | tools/update_manifest.dart; .github/workflows/manifest-expander.yml                                              | —                                                                      |
| CompleteIAPAdapter                    | Done   | packages/services/lib/monetization/in_app_purchase_adapter.dart                                                  | —                                                                      |
| AddIAPAdapterTests                    | Done   | packages/services/test/monetization/in_app_purchase_adapter_test.dart                                            | Consider adding an integration smoke with real plugin in future matrix |
| AddPurchasePersistenceIntegrationTest | Done   | packages/services/test/monetization/purchase_persistence_integration_test.dart                                   | —                                                                      |
| StrengthenStubParity                  | Done   | tools/check_stub_parity.dart; tools/parity_spec/in_app_purchase.json; ci.yml gate                                | Consider expanding parity coverage to additional stubs when introduced |
| RunAllPackagesCoverage                | Done   | tools/run_all_tests.sh; tools/run_all_package_coverage.dart; tools/merge_coverage.dart                           | Ensure CI uses the all-packages path when needed                       |
| UpdateMetricsAfterCoverage            | Done   | tools/update_metrics.dart; .github/workflows/metrics.yml                                                         | —                                                                      |
| ImproveParityTimestampGuard           | Done   | .github/workflows/ci.yml (STUB_PARITY_OK + STUB_PARITY_SPEC_HASH); tools/print_parity_spec_hash.dart             | —                                                                      |
| AddManifestCompletenessCheck          | Done   | tools/check_manifest.dart; ci.yml                                                                                | —                                                                      |
| EnforceQualityGates                   | Done   | tools/run_quality_gates.dart; ci.yml                                                                             | —                                                                      |
| PromoteAnalyzerWarnings               | Done   | analysis_options.yaml (promoted hints→errors)                                                                    | —                                                                      |
| EconomicsPersistenceIntegrationTest   | Done   | packages/services/test/economy/economy_persistence_integration_test.dart; economy_persistence_negative_test.dart | —                                                                      |

## P1 — Confidence & Visibility

| Task                    | Status  | Artifacts                                                                                                                                      | Gaps / Next                                                    |
| ----------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| AddReadmeBadges         | Partial | docs/METRICS.md; README markers (parity, workflows); docs/badges/\* via metrics                                                                | Add coverage/package-count badge surfaces to README if desired |
| TestAnalyticsEvents     | Done    | packages/services/lib/analytics/testing.dart; analytics tests (contract, economy, purchase, minimum event); ci gate via run_quality_gates.dart | —                                                              |
| AddGoldenTests          | Done    | .github/workflows/golden-guard.yml; docs/GOLDENS.md; examples/demo_game/test/goldens/_.dart; examples/demo_game/goldens/_.png                  | —                                                              |
| DocumentWorkflows       | Done    | docs/WORKFLOWS.md                                                                                                                              | Keep updated as workflows evolve                               |
| RouteIntegrityTests     | Done    | examples/demo_game/test/route_enumeration_integrity_test.dart; tools/route_spec/\*; main.dart fallbacks                                        | Extend with more deep links/modals as needed                   |
| LoggingConventionsDoc   | Done    | docs/LOGGING.md                                                                                                                                | —                                                              |
| ReleaseGatesIntegration | Done    | docs/RELEASE_GATES.md; tools/generate_release_gates_table.dart; .github/workflows/release-gates.yml                                            | —                                                              |

## P2 — Strategic Hardening

| Task                                 | Status  | Artifacts                                                                                                  | Gaps / Next                                                                        |
| ------------------------------------ | ------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| RealPluginMatrix                     | Done    | docs/REAL_PLUGIN_MATRIX.md; providers tests (real_plugin_matrix_test.dart); analytics_provider scaffolding | —                                                                                  |
| SemanticParityCheckAgainstRealPlugin | Partial | tools/build_symbol_map.dart; tools/diff_parity_vs_real.dart; docs/SEMANTIC_PARITY.md                       | Wire optional CI step to generate symbol map if plugin present; publish artifacts  |
| PerformanceSimulationTests           | Missing | —                                                                                                          | Introduce deterministic tick harness; add long-run simulation test with invariants |
| AddPerformanceHarness                | Missing | —                                                                                                          | Create packages/services/test_support/perf_harness.dart and wire into tests        |
| UIWidgetKeyAudit                     | Missing | —                                                                                                          | Audit key parameters across public widgets; add where helpful for test stability   |
| AddPackageStatusAudit                | Done    | tools/package_status_audit.dart; surfaced in docs/WORKFLOWS.md mapping                                     | Optionally wire as soft gate in CI/metrics to print results                        |
| RouteRegistrySpec                    | Done    | tools/route_spec/route_registry.json; spec hash tooling; route integrity test                              | —                                                                                  |
| EconomyErrorPathTests                | Partial | packages/services/test/economy/economy_persistence_negative_test.dart                                      | Add explicit DB failure injection and rollback assertion                           |
| CoverageThresholdRatcheting          | Done    | tools/coverage_ratchet.dart; .github/workflows/coverage-ratchet.yml                                        | —                                                                                  |
| ManifestDriftWatcher                 | Done    | tools/manifest_drift_watcher.dart; README hook instructions                                                | —                                                                                  |
| AddSpecHashes                        | Done    | tools/spec_hashes.dart; .github/workflows/spec-hashes.yml; docs/SPEC_HASHES.md                             | —                                                                                  |

## Meta / Helper

| Task                      | Status  | Artifacts                                                                                          | Gaps / Next                                                                           |
| ------------------------- | ------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| RunQualityGateSuite       | Done    | tools/run_quality_gates.dart; ci.yml                                                               | —                                                                                     |
| GenerateTaskChecklist     | Done    | tools/generate_task_checklist.dart; .github/workflows/checklist-visibility.yml; docs/VISIBILITY.md | —                                                                                     |
| AutoUpdateParitySpec      | Missing | —                                                                                                  | Add job to regenerate parity spec from real plugin symbol map and re-run parity check |
| AddDiffFriendlyFormatting | Done    | tools/spec_hashes.dart (stable sort/pretty); docs/SPEC_HASHES.md                                   | —                                                                                     |

## Notes

-    Route fallbacks and strict initial-route handling are implemented in `examples/demo_game/lib/main.dart` and validated by `route_enumeration_integrity_test.dart` (includes unknown-route to Home checks and NavigationDestination count parity).
-    Analytics tests consolidate NDJSON logging via `packages/services/lib/analytics/testing.dart`, and CI enforces a minimum analytics test presence.
-    Golden guard workflow is active with concrete goldens (home, home_rich, store) under `examples/demo_game/test/goldens/` and baselines in `examples/demo_game/goldens/`.

## Suggested Next PRs

1. Performance Harness (P2)

-    Create `packages/services/test_support/perf_harness.dart` and a basic simulation test to establish a baseline.

2. Semantic Parity (P2)

-    Introduce symbol-map extraction for the real plugin and a diff report step; store artifact under `docs/metrics/`.
