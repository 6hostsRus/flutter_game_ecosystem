# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

# Open Tasks

## SemanticParityCheckAgainstRealPlugin (P2)

Purpose: Higher-fidelity parity against the real plugin.

Steps:

1. Run `dart run tools/build_symbol_map.dart` against the real plugin (generate symbol JSON).
2. Diff stub spec vs real symbol map using `tools/diff_parity_vs_real.dart`.
3. Upload diff and symbols as artifacts; keep workflow non-blocking.

Validation:

-    Report produced and attached to CI artifacts.
-    Optional: add label/variable to trigger the parity workflow on PRs that touch related paths.

---

---

## ArchitectureStandardsReconciliation (P1)

Purpose: Reconcile `architecture/coding-standards.md` with existing docs under `docs/` and prepare a single standards document used to evaluate code changes.

Steps:

1. Read `architecture/coding-standards.md` and scan `docs/` for overlapping content (naming, formatting, testing, linting, commit/PR conventions).
2. Propose target doc path: `docs/CODING_STANDARDS.md` with a clear table of contents and cross-links to `analysis_options.yaml` and testing conventions.
3. Merge/rewrite sections to remove duplication; add “Evaluation Criteria” checklist used during reviews (inputs/outputs, tests, gates, docs updates).
4. Add a brief “How to apply” section referencing CI gates and pre-commit hooks.

Validation:

-    `docs/CODING_STANDARDS.md` exists, is linked from `docs/WORKFLOWS.md` and `ai_instructions.md`.
-    Checklist is referenced by `docs/AI_TASK_CHECKLIST.md` (or linked back).

---

## MonetizationDocsReconciliation (P1)

Purpose: Reconcile `monetization/monetization.md` with current AI/dev docs and encode missing tasks into this Task Library.

Steps:

1. Read `monetization/monetization.md` and map topics (adapters, test strategies, purchase flows, persistence, analytics) to existing docs/tests.
2. Identify gaps (e.g., edge-case flows, restore policy, sandbox/store config docs) and add concrete follow-up tasks here or as TODO links.
3. Propose target doc updates under `docs/` (e.g., `docs/monetization/overview.md`, `docs/monetization/testing.md`).
4. Ensure workflows that touch monetization (goldens, analytics, perf) are referenced from these docs.

Validation:

-    New or updated docs exist under `docs/monetization/` and are linked in `README.md#how-to-run-key-workflows` and `ai_instructions.md`.
-    This Task Library lists any net-new actionable monetization tasks with priorities.

---

## RoadmapMigrationAndPacingDoc (P1)

Purpose: Migrate `roadmap/*.md` to `docs/` and produce a phase pacing document defining key goals and metrics.

Steps:

1. Review `roadmap/` (e.g., `roadmap/phase-1.md`) and decide target location: `docs/roadmap/phase-1.md`.
2. Add a “Pacing & Metrics” section: goals, milestones, quality gates thresholds, and reporting cadence.
3. Cross-link relevant workflows and metrics documents (coverage, perf, parity, spec hashes).
4. Link the roadmap phase from `README.md` and `ai_instructions.md`.

Validation:

-    `docs/roadmap/phase-1.md` exists with a metrics checklist and references to CI artifacts.
-    Links resolve from README and AI instructions.

---

## OpsDocsReconciliation (P1)

Purpose: Reconcile operational quick ops and secrets documentation; consolidate under docs and remove redundant root files.

Steps:

1. Review root `QUICK_OPS.md` and `secrets.example.md` alongside `automation/README.md`, `automation/secrets.example.md`, and `docs/WORKFLOWS.md`.
2. Decide target locations (e.g., `docs/platform/release.md`, `docs/WORKFLOWS.md`, or `docs/automation/`), migrate content, and create clear pointers.
3. Ensure examples avoid real secrets and demonstrate environment variables/secrets usage for CI and local runs.
4. Remove duplicated root files or replace with stubs linking to the new canonical docs.

Validation:

-    Docs consolidated; links in README and ai_instructions updated.
-    Redundant root entries removed or stubbed with pointers.

---

# Helper / Meta Tasks

No open meta tasks at this time.

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
