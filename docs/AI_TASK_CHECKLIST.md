#!/usr/bin/env markdown

# AI Task Execution Checklist

Updated: 2025-09-06

Purpose: A standardized, lightweight checklist to execute tasks from `docs/AI_TASK_LIBRARY.md`, keep reconciliation current, and reflect CI/metrics changes.

## Use this for every task

1. Scope & Requirements

-    Read the user ask and the relevant sections in `docs/AI_TASK_LIBRARY.md`.
-    Extract explicit requirements into a short checklist; note 1–2 reasonable assumptions if details are missing.

2. Context & Planning

-    Batch-read only what’s needed (prefer larger, meaningful chunks).
-    Keep a tiny contract (inputs/outputs, success criteria, 2–3 edge cases).

3. Execute with Cadence

-    Batch independent, read-only steps; checkpoint after ~3–5 actions.
-    When editing >3 files, checkpoint with a compact summary of changes.
-    Prefer concrete edits/tests over advice; take action when possible.

4. Tests & Quality Gates

-    Add or update minimal tests (happy path + 1–2 edges) when public behavior changes.
-    Run/verify gates where relevant: manifest, parity, coverage, analytics tests, route/spec hashes, perf thresholds.

5. CI/Docs/Badges Updates

-    If workflows changed, update `docs/WORKFLOWS.md` (name, triggers, key steps, outputs).
-    Update metrics with `dart run tools/update_metrics.dart` (emits global and per-package badges under `docs/badges/`).
-    Root README: keep badges minimal. Package READMEs: prefer per-package endpoints (coverage*<pkg>.json, analytics*<pkg>.json, pkg*warn*<pkg>.json).

6. Reconciliation

-    Update `docs/AI_TASK_RECONCILIATION.md`: set Status (Done/Partial), list Artifacts, and capture Gaps/Next if any.

7. Commits & PRs

-    Use concise, prefixed messages (e.g., `chore(metrics): …`, `docs(workflows): …`, `ci: …`).
-    For larger changes, summarize validation (build/lint/tests PASS) and any follow-ups.

Notes

-    Optional artifacts (e.g., semantic parity auto-update) should be non-blocking in CI but upload artifacts for visibility.
-    Avoid over-automation in a single PR; keep risk low and value visible.
