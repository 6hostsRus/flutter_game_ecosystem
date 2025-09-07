# Changelog

All notable changes to this project will be documented in this file.

Guidelines:

-    Keep entries concise and grouped by category.
-    Prefer linking to scripts/workflows/docs touched.
-    Use ISO dates (YYYY-MM-DD).

## [Unreleased]

-    Placeholder.

## 2025-09-06

Highlights

-    Metrics & Badges

     -    Repo and per-package shields emitted to `docs/badges/` (coverage*<pkg>.json, analytics*<pkg>.json, pkg*warn*<pkg>.json).
     -    Package READMEs wired to per-package endpoints; root README shows aggregate badges.
     -    Metrics publisher updated to generate and commit new badges. See `.github/workflows/metrics.yml` and `tools/update_metrics.dart`.

-    Testing & Reliability

     -    Migrated demo tests to stable Keys; reduced flakiness.
     -    Expanded Economy error-path and persistence tests.
     -    Added analytics contract tests and minimum presence gate.
     -    Golden guard workflow established for UI baselines.

-    Performance

     -    Perf simulation harness and thresholds added; CI checks p95 and action counts. See `.github/workflows/perf-metrics.yml` and `tools/check_perf_metrics.dart`.

-    Parity & Specs

     -    Non-blocking auto-update of stub parity spec integrated into metrics workflow.
     -    Optional semantic parity workflow added to diff real plugin vs spec and upload artifacts.
     -    Route registry/spec hash tracking surfaced. See `tools/spec_hashes.dart` and `.github/workflows/spec-hashes.yml`.

-    Docs & Workflows
     -    Consolidated stack docs workflow and docs catalog (`docs/WORKFLOWS.md`).
     -    Introduced AI Task Checklist and Library prompt; `ai_instructions.md` converted to an index.
     -    Release gates mapping doc and workflow.

References: `docs/WORKFLOWS.md`, `docs/AI_TASK_RECONCILIATION.md`, `docs/AI_TASK_LIBRARY.md`.
