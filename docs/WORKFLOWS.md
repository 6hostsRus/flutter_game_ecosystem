# CI & Automation Workflows

Authoritative catalog of GitHub Actions workflows powering quality gates, releases, and automation. Each entry: Name | File | Trigger(s) | Key Steps | Outputs / Gates.

> Source of truth: `.github/workflows/*.yml`. Update this doc when adding/modifying workflows.

## Core Quality Gates

### Continuous Integration

-    File: `.github/workflows/ci.yml`
-    Triggers: push (main), pull_request
-    Key Steps: Dart/Flutter setup, run `tools/quality_gates.dart` (parity, manifest, coverage, analytics tests), run unit tests & coverage merge, upload coverage artifact.
-    Outputs: Fails PR if any gate fails.

### Metrics Publisher

-    File: `.github/workflows/metrics.yml`
-    Triggers: schedule (cron), manual dispatch, post-merge
-    Key Steps: Run tests + coverage, `dart run tools/update_metrics.dart`, commit updated `docs/METRICS.md` & `docs/badges/coverage.json`.
-    Outputs: Updated metrics & shield JSON.

### Golden Guard

-    File: `.github/workflows/golden-guard.yml`
-    Triggers: pull_request touching UI packages or golden assets
-    Key Steps: Run Flutter golden tests (future P1 AddGoldenTests), compare snapshots.
-    Outputs: Fails on golden diffs.

### Policy Guard

-    File: `.github/workflows/policy-guard.yml`
-    Triggers: pull_request
-    Key Steps: Secret scanning (gitleaks), license / compliance checks (future), basic security linters.
-    Outputs: Blocks merge on policy violations.

### Gitleaks

-    File: `.github/workflows/gitleaks.yml`
-    Triggers: push, pull_request
-    Key Steps: Run gitleaks scan.
-    Outputs: Fail on secret patterns.

## Release & Versioning

### Release Please

-    File: `.github/workflows/release-please.yml`
-    Triggers: push to main
-    Key Steps: Conventional commits parsing, draft release PR / tags.
-    Outputs: Automated changelog & version bumps.

### Release Candidate Builder

-    File: `.github/workflows/release-candidate.yml`
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

### Screenshots

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

## Quality Gate Mapping

| Gate                        | Source Script                                    | Enforced In          |
| --------------------------- | ------------------------------------------------ | -------------------- |
| Manifest completeness       | `tools/check_manifest.dart`                      | ci.yml               |
| Stub parity                 | `tools/check_stub_parity.dart`                   | ci.yml               |
| Coverage >= threshold       | `tools/run_quality_gates.dart` (aggregates)      | ci.yml               |
| Analytics tests >=1         | `tools/run_quality_gates.dart`                   | ci.yml               |
| Route spec hash (strict)    | `tools/check_spec_hashes.dart --strict`          | ci.yml               |
| Route registry spec         | `tools/check_route_registry.dart`                | ci.yml               |
| Spec hashes tracked         | `tools/spec_hashes.dart`                         | metrics.yml          |
| Manifest drift watcher      | `tools/manifest_drift_watcher.dart` (pre-commit) | local dev            |
| Package status audit (warn) | `tools/package_status_audit.dart`                | ci.yml / metrics.yml |

## Update Procedure

1. Modify / add workflow YAML.
2. Run locally (act or dry-run) if complex.
3. Update this file with: purpose, triggers, key steps, outputs.
4. Open PR referencing "DocumentWorkflows" task.

---

Generated via AI task: DocumentWorkflows (P1). Keep concise and actionable.
