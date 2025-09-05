# AI Task Library

Reusable task blueprints.

## CreateOrUpdateManifest

1. Read existing `packages/manifest.yaml`.
2. Merge new packages; preserve unknown keys.
3. Sort alphabetically; update last_updated.
4. Validate paths exist.

## ConsolidateStackDocs

1. Build `docs/STACK.md` from scattered sources.
2. Insert deprecation banners in superseded docs.

## HardenMonetizationAdapter

1. Add factory (if missing).
2. Add/Update adapter tests (status mapping).
3. Introduce feature flag for real plugin.

## AddStubParityCheck

1. Create/update `tools/check_stub_parity.dart`.
2. Ensure parity TODO tags exist.

## ScaffoldMetrics

1. Ensure `docs/METRICS.md` markers present.
2. (Later) Update from CI.

## ModularizeAIInstructions

1. Generate AI\_\* docs.
2. Replace root instructions with index linking.

## UpdateStub

1. Modify stub file.
2. Adjust parity date.
3. Run parity script.

## AddTest

1. Create test file mirroring lib path.
2. Import necessary fakes.
3. Assert key behaviors & edge cases.

---

# Extended Task Library (Risk & Drift Remediation)

The following tasks map to Risk/Drift (P0–P2) and Actionable Next Commit Set.

## ExpandManifestFull (P0)

Purpose: Eliminate manifest drift (High risk).
Steps:

1. Discover all packages: scan `packages/` and selected `examples/`.
2. For each missing package, add entry with role/status guess; do not overwrite existing custom fields.
3. Add any test-support or tool packages (e.g., stubs, adapters).
4. Update `last_updated`.
   Validation:

-    Every directory with a `pubspec.yaml` (excluding hidden/tooling) appears exactly once.
-    Metrics updater reflects new package count.

## CompleteIAPAdapter (P0)

Purpose: Replace placeholder `{…}` sections.
Steps:

1. Implement `_onPurchaseUpdates`, `availability`, `checkout`, `restorePurchases`, `dispose`.
2. Map upstream statuses to internal enum (pending, success, failure, cancelled, restored).
3. Ensure error handling: timeouts, user cancellation, verification failure (placeholder codes).
4. Acknowledge/complete purchases where required.
   Validation:

-    New unit tests (see AddIAPAdapterTests) pass.
-    No analyzer TODO placeholders remain in adapter core methods.

## AddIAPAdapterTests (P0)

Purpose: Increase confidence in monetization logic.
Scenarios:

1. Success flow (purchased).
2. Pending then purchased.
3. User cancelled.
4. Error (failed) surfaces error code.
5. Restore emits restored results.
6. Unavailable store returns empty SKU list & availability flag false.
   Validation:

-    All tests green; line coverage on adapter ≥ 80%.

## AddPurchasePersistenceIntegrationTest (P0)

Purpose: Verify wallet updated & persisted.
Steps:

1. Use fake IAP + in‑memory or temp Isar instance.
2. Purchase consumable → update wallet → close DB → reopen → assert balance persisted.
3. Include negative test: failed purchase does not alter persisted balance.
   Validation:

-    Test passes consistently (run twice to ensure isolation).

## StrengthenStubParity (P0)

Purpose: Move beyond token presence.
Steps:

1. Read stub file contents.
2. Parse signatures (class names, public methods, enums).
3. Maintain a JSON manifest (e.g. `tools/parity_spec/in_app_purchase.json`) listing required symbols.
4. Compare sets; fail if any missing or extra (unless whitelisted).
   Validation:

-    Parity script output lists 0 discrepancies.
-    CI fails when symbol removed.

## RunAllPackagesCoverage (P0)

Purpose: Accurate coverage metric.
Steps:

1. Introduce a root script `tools/run_all_tests.sh` (or Dart) invoking `dart test` in each package with `--coverage`.
2. Merge results with existing merge script.
3. Update metrics after merge.
   Validation:

-    Coverage reflects multi-package lines (non-zero increase vs prior).
-    No package skipped (log package list).

## UpdateMetricsAfterCoverage (P0)

Purpose: Ensure METRICS stays consistent.
Steps:

1. Run coverage pipeline.
2. Execute metrics updater.
3. Confirm coverage % updated & package count matches manifest.
   Validation:

-    `docs/METRICS.md` markers filled; badge JSON updated.

## ImproveParityTimestampGuard (P0)

Purpose: Only stamp timestamp when parity truly passed in same run.
Steps:

1. Metrics script: require both env flags `STUB_PARITY_OK=1` and `STUB_PARITY_SPEC_HASH=<hash>`.
2. Compute hash of parity spec JSON to detect drift.
   Validation:

-    Timestamp unchanged if parity not run or failed.

## AddManifestCompletenessCheck (P0)

Purpose: Gate CI on manifest correctness.
Steps:

1. Script `tools/check_manifest.dart`:
     - Enumerate package dirs with `pubspec.yaml`.
     - Compare with manifest entries.
2. Fail if discrepancies found.
   Validation:

-    CI fails when adding a new package without manifest update.

## EnforceQualityGates (P0)

Purpose: Formalize gates (coverage, parity, manifest).
Steps:

1. Central script returns non-zero exit if thresholds unmet.
2. Integrate into CI before build/test.
3. Configure thresholds (e.g., coverage >= 55% initial).
   Validation:

-    Intentional threshold breach causes CI red.

## PromoteAnalyzerWarnings (P0)

Purpose: Turn critical hints into errors.
Steps:

1. Update `analysis_options.yaml`: add `error` severity for chosen lints (e.g., unused_import, dead_code, unnecessary_null_checks).
2. Run analyzer; fix surfaced issues.
   Validation:

-    No promoted warnings remain.

## EconomicsPersistenceIntegrationTest (P0)

Purpose: Ensure economy ledger & profile sync.
Steps:

1. Simulate earning + spend across sessions.
2. Persist via Isar; rehydrate; verify net balance & transaction log integrity.
   Validation:

-    All asserts pass; test deterministic.

## AddReadmeBadges (P1)

Purpose: Surface key metrics.
Steps:

1. Insert coverage badge (static shields JSON endpoint).
2. Insert package count & last parity timestamp (inline markers or manual text).
   Validation:

-    Badges render correctly in GitHub preview.

## TestAnalyticsEvents (P1)

Purpose: Validate analytics dispatch contract.
Steps:

1. Provide fake analytics sink capturing events.
2. Trigger representative events (purchase, navigation, economy changes).
3. Assert naming, parameter presence, value formatting.
   Validation:

-    All expected events captured; no unexpected nulls.

## AddGoldenTests (P1)

Purpose: Protect UI shell visuals.
Steps:

1. Select critical widgets (HUD, store screen).
2. Set deterministic theme + media query.
3. Render & capture baseline golden.
4. Add variation (e.g., different balances).
   Validation:

-    Goldens pass locally; document updating procedure.

## DocumentWorkflows (P1)

Purpose: Transparency of automation.
Steps:

1. Create `docs/WORKFLOWS.md`.
2. For each workflow: name, triggers, key steps, outputs, gating conditions.
3. Link from README.
   Validation:

-    All YAML workflow filenames appear in doc.

## RouteIntegrityTests (P1)

Purpose: Navigation safety.
Steps:

1. Enumerate registered routes.
2. Attempt programmatic navigation for each.
3. Assert no runtime exceptions & correct widget type.
   Validation:

-    All route tests pass.

## LoggingConventionsDoc (P1)

Purpose: Standardize logs across services.
Steps:

1. Add `docs/LOGGING.md`: format, levels, correlation IDs.
2. Reference doc in STACK.md.
   Validation:

-    Stack doc link resolves.

## ReleaseGatesIntegration (P1)

Purpose: Align release checklist & CI.
Steps:

1. Map each release checklist item to a CI check or script.
2. Add table to `platform/checklists/meta_release.md`.
   Validation:

-    All P0 gates appear in release doc mapping.

## RealPluginMatrix (P2)

Purpose: Prepare real IAP plugin adoption.
Steps:

1. Add optional dependency path or version (feature flagged).
2. CI matrix job: `USE_REAL_IAP=true` build only (may skip tests initially).
3. Document risk & fallback.
   Validation:

-    Real plugin compile job succeeds (ignore platform channels at first).

## SemanticParityCheckAgainstRealPlugin (P2)

Purpose: Higher-fidelity parity.
Steps:

1. Temporary isolate: Run `dart run build_symbol_map.dart` against real plugin (generate symbol JSON).
2. Diff stub spec vs real symbol map.
3. Report added/removed/changed items.
   Validation:

-    Report produced & stored as artifact.

## PerformanceSimulationTests (P2)

Purpose: Detect regressions in idle/game loop.
Steps:

1. Create simulation harness with deterministic ticks (e.g., 10k tick run).
2. Measure allocations (optional) & ensure state convergence (no divergence drift).
   Validation:

-    Simulation completes under time budget & asserts invariants.

## AddPerformanceHarness (P2)

Purpose: Shared test utility.
Steps:

1. Add `packages/services/test_support/perf_harness.dart`.
2. Provide `runTicks(int count, Duration step)`.
   Validation:

-    Harness used by PerformanceSimulationTests.

## UIWidgetKeyAudit (P2)

Purpose: Stability for widget tests.
Steps:

1. Enumerate public widgets missing keys.
2. Add optional `Key? key` parameters & forward to super.
   Validation:

-    Analyzer no longer suggests missing keys for targeted widgets.

## AddPackageStatusAudit (P2)

Purpose: Keep status metadata accurate.
Steps:

1. Script reads manifest entries.
2. Warn if status=experimental for > N days.
3. Output table to console / CI log.
   Validation:

-    CI logs audit summary.

## RouteRegistrySpec (P2)

Purpose: Formalize expected routes.
Steps:

1. JSON spec listing routes + widget class.
2. Test ensures implementation matches spec.
   Validation:

-    Spec diff surfaces intentional changes.

## EconomyErrorPathTests (P2)

Purpose: Fault injection.
Steps:

1. Simulate failed DB write.
2. Assert rollback / retry path does not corrupt balances.
   Validation:

-    No net balance drift.

## CoverageThresholdRatcheting (P2)

Purpose: Progressive improvement.
Steps:

1. Store current threshold in `tools/coverage_policy.yaml`.
2. If actual coverage > threshold + 1%, bump threshold automatically in a separate PR.
   Validation:

-    Policy file updates only when condition met.

## ManifestDriftWatcher (P2)

Purpose: Early warning of drift.
Steps:

1. Lightweight pre-commit hook checking manifest sync.
2. Provide add command if missing.
   Validation:

-    Commit blocked when drift detected.

## AddSpecHashes (P2)

Purpose: Track parity spec evolution.
Steps:

1. Compute hash for each spec file (stub parity & route registry).
2. Store in `docs/SPEC_HASHES.md`.
   Validation:

-    Update script recalculates & diffs.

---

# Helper / Meta Tasks

## RunQualityGateSuite

1. Execute: parity check, manifest check, coverage threshold check.
2. Summarize pass/fail table.
3. Fail if any gate fails.

## GenerateTaskChecklist

1. Parse this file.
2. Produce Markdown table (Task, Priority, Status placeholder).
3. Save to `docs/TASK_STATUS.md`.

## AutoUpdateParitySpec

1. Pull real plugin symbols (if available).
2. Update parity JSON spec.
3. Re-run strengthened parity script.

## AddDiffFriendlyFormatting

1. Ensure generated JSON/YAML sorted & pretty.
2. Re-run formatting & commit.

---

# Task Priority Legend

-    P0: Immediate; blocks reliability or correctness.
-    P1: Important; improves confidence & visibility.
-    P2: Strategic; longer-term resilience & scalability.

# Validation Summary Template (for each executed task)

Task: <Name>
Files Added/Modified:
Validation Commands Run:
New Analyzer Issues: 0
New Tests Added: #
Coverage Delta: +X.Y%
Follow-ups: (if any)

---

// End of AI Task
