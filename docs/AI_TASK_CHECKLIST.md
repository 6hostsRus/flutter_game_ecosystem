#!/usr/bin/env markdown

# AI Task Execution Checklist

Updated: 2025-09-06

Purpose: A standardized, lightweight checklist to execute tasks from `docs/AI_TASK_LIBRARY.md`, keep reconciliation current, and reflect CI/metrics changes.

Note: When presenting multiple approaches, options, or branches, always present them as numbered options (1., 2., 3., ...). The user may reply with a single number (e.g., "2") or a range (e.g., "1-3") to select one or more options. Use this selection convention in generated task lists and migration plans.

## Use this for every task

1. Scope & Requirements

-    Read the user ask and the relevant sections in `docs/AI_TASK_LIBRARY.md`.
-    Extract explicit requirements into a short checklist; note 10 reasonable assumptions if details are missing.

2. Context & Planning

-    Batch-read only whats needed (prefer larger, meaningful chunks).
-    Keep a tiny contract (inputs/outputs, success criteria, 23 edge cases).
-    Review against Coding Standards evaluation checklist: `docs/CODING_STANDARDS.md`.

3. Repo-wide refactors (mandatory steps)

-    Run `melos bootstrap` at the repo root before attempting analysis or tests for multi-package changes.
-    Create a package-level migration plan: list affected packages, ordered PRs (one package or small subtree per PR), and required validation steps per PR.
-    For every package in the migration plan: include a smoke test (see Quality Gates below) and a minimal rollback/deprecation path.
-    When >3 packages or >20 files change, split work into a series of PRs and include a migration README in the first PR that documents the full strategy.

4. Execute with Cadence

-    Batch independent, read-only steps; checkpoint after ~35 actions.
-    When editing >3 files, checkpoint with a compact summary of changes.
-    Prefer concrete edits/tests over advice; take action when possible.

5. Tests & Quality Gates

-    Add or update minimal tests (happy path + 12 edges) when public behavior changes.
-    Run/verify gates where relevant: manifest, parity, coverage, analytics tests, route/spec hashes, perf thresholds.
-    For package-level validation use: `melos run analyze --scope <package>` and `melos run test --scope <package>`.

6. CI/Docs/Badges Updates

-    If workflows changed, update `docs/WORKFLOWS.md` (name, triggers, key steps, outputs).
-    Update metrics with `dart run tools/update_metrics.dart` (emits global and per-package badges under `docs/badges/`).
-    Root README: keep badges minimal. Package READMEs: prefer per-package endpoints (coverage*<pkg>.json, analytics*<pkg>.json, pkg*warn*<pkg>.json).

7. Changelog

-    If user-facing or developer-visible changes were made (docs, CI gates, metrics, workflows, tests), add a brief entry to `CHANGELOG.md` under the current date, linking key scripts/workflows.

8. Reconciliation

-    Update `docs/AI_TASK_RECONCILIATION.md`: set Status (Done/Partial), list Artifacts, and capture Gaps/Next if any.

9. Commits & PRs

-    Use concise, prefixed messages (e.g., `chore(metrics): \u2026`, `docs(workflows): \u2026`, `ci: \u2026`).
-    For larger changes, summarize validation (build/lint/tests PASS) and any follow-ups.

Notes

-    Optional artifacts (e.g., semantic parity auto-update) should be non-blocking in CI but upload artifacts for visibility.
-    Avoid over-automation in a single PR; keep risk low and value visible.
-    Consider when new branches need made to update the repository. Present git commands to do so when necessary to keep work organized and trackable.
-    Generate meaningful commit messages when it is time for a commit.
-    When relocating or deleting a file, present terminal commands to do so in order to avoid user confusion instead of generating new files to reflect changes from file moves.
-    When working on multi-package changes, require `melos bootstrap` before running analysis or tests.
