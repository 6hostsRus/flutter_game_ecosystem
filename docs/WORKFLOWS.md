# CI & Automation Workflows

Authoritative catalog of GitHub Actions workflows powering quality gates, releases, and automation. Each entry: Name | File | Trigger(s) | Key Steps | Outputs / Gates.

> Source of truth: `.github/workflows/*.yml`. Update this doc when adding/modifying workflows.

Note: See `docs/CODING_STANDARDS.md` for review expectations that CI gates support.

## Core Quality Gates

### Continuous Integration

-    File: `.github/workflows/ci.yml`
-    Triggers: push (main), pull_request
-    Key Steps: Dart/Flutter setup, run `tools/quality_gates.dart` (parity, manifest, coverage, analytics tests), run unit tests & coverage merge, validate content pack schemas against `packages/game_core/assets/schemas/`, upload coverage artifact.
     Quick local usage: see [README](../README.md#schema-validation).
-    Outputs: Fails PR if any gate fails.

### Metrics Publisher

-    File: `.github/workflows/metrics.yml`
-    Triggers: schedule (cron), manual dispatch, post-merge
-    Key Steps: Run tests + coverage, `dart run tools/update_metrics.dart`, commit updated `docs/METRICS.md` & `docs/badges/*.json`. Additionally, attempts non-blocking parity auto-update: build symbol map and regenerate `tools/parity_spec/<pkg>.json`; commits and uploads artifacts when changed.
-    Outputs: Updated metrics & shields; optional parity spec + symbols artifacts.
-    Notes: Also emits per-package badges under `docs/badges/` (e.g., `coverage_<pkg>.json`, `analytics_<pkg>.json`, `pkg_warn_<pkg>.json`) for use in package READMEs.

### Golden Guard

-    File: `.github/workflows/golden-guard.yml`
-    Triggers: pull_request touching UI packages or golden assets
-    Key Steps: Run Flutter golden tests (future P1 AddGoldenTests), compare snapshots.
-    Outputs: Fails on golden diffs.

### Perf Metrics

-    File: `.github/workflows/perf-metrics.yml`
-    Triggers: push (main), pull_request, workflow_dispatch
-    Key Steps: Install Flutter, run perf simulation test (writes `packages/services/build/metrics/perf_simulation.json`), validate thresholds via `dart run tools/check_perf_metrics.dart`, upload metrics artifact.
-    Outputs: Artifact with perf JSON; fails PR if thresholds regress (p95 too high or action counts too low).

### Policy Guard

-    File: `.github/workflows/policy-guard.yml`
-    Triggers: pull_request
-    Key Steps: Secret scanning (gitleaks), license / compliance checks (future), basic security linters.
-    Outputs: Blocks merge on policy violations.

### Gitleaks

## Release & Versioning

-    Key Steps: Conventional commits parsing, draft release PR / tags.
-    Outputs: Automated changelog & version bumps.
-    Triggers: workflow_dispatch, RC branch pattern
-    Key Steps: Build platform artifacts, (future) upload to internal channels.
-    Outputs: RC artifacts.

### Hotfix

-    File: `.github/workflows/hotfix.yml`
-    Triggers: workflow_dispatch
-    Key Steps: Cherry-pick or fast-forward patch release path, run tests.
-    Outputs: Patched release tag.

### Store Sync

-    File: `.github/workflows/store-sync.yml`
-    Triggers: schedule, manual
-    Key Steps: Placeholder (future) for syncing store metadata / screenshots.
-    Outputs: Synced store assets (planned).

### Submit iOS / Android Internal

-    Files: `.github/workflows/submit-ios.yml`, `.github/workflows/android-internal.yml`
-    Triggers: manual dispatch (gated by secrets)
-    Key Steps: Build IPA / AAB, (future) submit via API.
-    Outputs: Uploaded build (future).

## Content & Docs

### Docsite Publisher

-    File: `.github/workflows/docsite.yml`
-    Triggers: push to docs paths, manual
-    Key Steps: Build static docs (future), deploy to GH Pages.
-    Outputs: Updated documentation site.

### Checklist Visibility Publisher

-    File: `.github/workflows/checklist-visibility.yml`
-    Triggers: push to main (ignores self-updates), manual dispatch
-    Key Steps: Run `dart run tools/generate_task_checklist.dart`, commit `docs/VISIBILITY.md`, `docs/metrics/task_checklist.json`, and README marker.
-    Outputs: Up-to-date checklist visibility report and JSON for dashboards.

### Release Gates Mapping

-    File: `.github/workflows/release-gates.yml`
-    Triggers: push to main (ignores self-updates), manual dispatch
-    Key Steps: Run `dart run tools/generate_release_gates_table.dart`, commit `docs/RELEASE_GATES.md`, `docs/metrics/release_gates.json`, and README marker.
-    Outputs: Up-to-date release gates mapping doc and JSON.

### Spec Hashes Updater

-    File: `.github/workflows/spec-hashes.yml`
-    Triggers: push to main (ignores self-updates), manual dispatch
-    Key Steps: Run `dart run tools/spec_hashes.dart --write`, commit `docs/SPEC_HASHES.md` and `docs/metrics/spec_hashes.json` only when hashes change (diff-friendly).
-    Outputs: Stable spec hashes doc and JSON for dashboards.

### Semantic Parity (Optional Artifacts)

-    File: `.github/workflows/auto-update-parity-spec.yml`
-    Triggers: workflow_dispatch (input: `enable=true`)
-    Key Steps: Build symbol map via `dart run tools/build_symbol_map.dart`, auto-generate `tools/parity_spec/<pkg>.json` via `dart run tools/auto_update_parity_spec.dart`, run stub parity check, upload artifacts.
-    Outputs: Updated parity spec and symbol map uploaded as artifacts; no enforced gate.

### Screenshots

### Changelog Reminder

-    File: `.github/workflows/changelog-reminder.yml`
-    Triggers: pull_request
-    Key Steps: Check PR changes for workflow/doc/metrics/test alterations; if detected and `CHANGELOG.md` not modified, leave a PR comment and set a neutral status.
-    Outputs: Friendly reminder to update changelog (non-blocking).

### Consolidate Stack Docs

-    File: `.github/workflows/consolidate-stack.yml`
-    Triggers: push (main; ignores self-updates), manual dispatch
-    Key Steps: Bootstrap workspace via Melos, run `dart run tools/consolidate_stack_docs.dart`, commit updated `docs/STACK.md`, `docs/metrics/stack_index.json`, and `README.md` if changed.
-    Outputs: Up-to-date consolidated stack documentation. Supports the "ConsolidateStackDocs" item in the AI Task Library.

-    File: `.github/workflows/screenshots.yml`
-    Triggers: manual, future commit triggers
-    Key Steps: Launch device matrix, capture game template screenshots.
-    Outputs: Updated image assets.

## Project & Issue Automation

### Auto Label / Labeler

-    Files: `.github/workflows/auto-label.yml`, `.github/workflows/labeler.yml`
-    Triggers: pull_request
-    Key Steps: Apply labels from paths / heuristics.
-    Outputs: Consistent labeling.

### Add To Project

-    File: `.github/workflows/add-to-project.yml`
-    Triggers: issues / PR opened
-    Key Steps: Add item to GitHub project board.
-    Outputs: Backlog consistency.

### Project Move / Epic Builder / RC Generator

-    Files: `project-move.yml`, `epic-builder.yml`, `rc-generator.yml`
-    Triggers: manual or issue events
-    Key Steps: Create / move epics, generate RC branches or issues.
-    Outputs: Structured planning artifacts.

### Stale / Notify / Triage Release

-    Files: `stale.yml`, `notify.yml`, `triage-release.yml`
-    Triggers: schedule or issue events
-    Key Steps: Mark stale issues, send notifications, prep release triage notes.
-    Outputs: Maintained issue hygiene.

## Analytics & Future Hooks

-    Planned: Add workflow to fail if analytics event taxonomy doc out-of-sync with observed events in tests.
-    CoverageThresholdRatcheting (P2) implemented locally via `tools/coverage_ratchet.dart` (CI auto-bump step TBD).

### Coverage Ratchet

-    File: `.github/workflows/coverage-ratchet.yml`
-    Triggers: scheduled daily, manual
-    Key Steps: run tests to generate coverage, run `tools/coverage_ratchet.dart`, commit updated `tools/coverage_policy.yaml` if bump needed.
-    Outputs: Gradual automatic increase of minimum coverage.

### Manifest Expander

-    File: `.github/workflows/manifest-expander.yml`
-    Triggers: push to main (ignores self-updates), manual
-    Key Steps: run `dart run tools/update_manifest.dart`, commit `packages/manifest.yaml` when missing packages discovered.
-    Outputs: Up-to-date manifest with new packages.
     Notes: Implements the "CreateOrUpdateManifest" flow to prevent drift during future package additions/migrations.

### Semantic Parity (Real Plugin Diff)

-    File: `.github/workflows/semantic-parity.yml`
-    Triggers: pull_request (tools/parity or IAP paths), manual dispatch with `enable=true`
-    Key Steps: Build symbol map via `dart run tools/build_symbol_map.dart`, diff against parity spec using `dart run tools/diff_parity_vs_real.dart`, upload diff and symbols as artifacts.
-    Outputs: Parity diff report JSON and symbol map for inspection (non-blocking by default).

## Quality Gate Mapping

| Gate                        | Source Script                                    | Enforced In                              |
| --------------------------- | ------------------------------------------------ | ---------------------------------------- |
| Manifest completeness       | `tools/check_manifest.dart`                      | ci.yml                                   |
| Stub parity                 | `tools/check_stub_parity.dart`                   | ci.yml                                   |
| Coverage >= threshold       | `tools/run_quality_gates.dart` (aggregates)      | ci.yml                                   |
| Analytics tests >=1         | `tools/run_quality_gates.dart`                   | ci.yml                                   |
| Route spec hash (strict)    | `tools/check_spec_hashes.dart --strict`          | ci.yml                                   |
| Route registry spec         | `tools/check_route_registry.dart`                | ci.yml                                   |
| Spec hashes tracked         | `tools/spec_hashes.dart`                         | metrics.yml                              |
| Manifest drift watcher      | `tools/manifest_drift_watcher.dart` (pre-commit) | local dev                                |
| Package status audit (warn) | `tools/package_status_audit.dart`                | ci.yml / metrics.yml                     |
| Perf thresholds (warn/fail) | `tools/check_perf_metrics.dart`                  | perf-metrics.yml                         |
| Parity auto-update (opt)    | `tools/auto_update_parity_spec.dart`             | metrics.yml, auto-update-parity-spec.yml |
| Changelog reminder (soft)   | n/a (path-based check)                           | changelog-reminder.yml                   |
| Stack consolidation         | `tools/consolidate_stack_docs.dart`              | consolidate-stack.yml                    |
| Semantic parity diff (opt)  | `tools/diff_parity_vs_real.dart`                 | semantic-parity.yml                      |
| Platform release (guarded)  | n/a (build steps in workflow)                    | platform-release.yml                     |

### Platform Release (Guarded)

-    File: `.github/workflows/platform-release.yml`
-    Triggers: workflow_dispatch (inputs: `enable`, `release_platform`, `release_track`)
-    Key Steps: Guarded build for android/ios/web; artifact upload if present. Optional store uploads when secrets are configured (`PLAY_JSON_KEY` for Android; `APPSTORE_KEY_ID`, `APPSTORE_ISSUER_ID`, `APPSTORE_P8` for iOS).
-    Outputs: Build artifacts for targeted platform; non-blocking, manual-only.
     See: `docs/platform/release.md` for inputs, secrets, and examples.

## Update Procedure

1. Modify / add workflow YAML.
2. Run locally (act or dry-run) if complex.
3. Update this file with: purpose, triggers, key steps, outputs.
4. Open PR referencing "DocumentWorkflows" task.
5. Cross-check changes against `docs/AI_TASK_CHECKLIST.md` (tests, gates, metrics/badges, reconciliation updates).

---

Generated via AI task: DocumentWorkflows (P1). Keep concise and actionable.
