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

-    New or updated docs exist under `docs/monetization/` and are linked in `README_unified_stack.md` and `ai_instructions.md`.
-    This Task Library lists any net-new actionable monetization tasks with priorities.

---

## PlatformDocsMigration (P1)

Purpose: Reconcile `platform/` contents and migrate into `docs/` with an instruction set for developers.

Steps:

1. Inventory `platform/` (android_vs_ios.md, device_targets.md, hosting_options.md, dev_programs.md, checklists/ etc.).
2. Create a `docs/platform/` tree; migrate content with unified structure and cross-links to build/release workflows.
3. Add an index page summarizing targets, env setup, and checklists; ensure duplication is removed.
4. Update `docs/WORKFLOWS.md` links to point to migrated docs.

Validation:

-    `docs/platform/*` mirrors relevant guidance; old files point to new locations or are removed in a follow-up PR.
-    Links in `README.md`/`ai_instructions.md` resolve to the new docs.

---

## PlatformReleaseCIIntegration (P1)

Purpose: Develop CI integrations for platform release toggled by repository variables/inputs.

Steps:

1. Add or update a workflow (e.g., `.github/workflows/platform-release.yml`) with inputs/vars: `release_platform`, `release_track`, and `ENABLE_PLATFORM_RELEASE`.
2. Implement guarded jobs (only run when enabled) to build and, optionally, upload artifacts (manual steps acceptable initially).
3. Document variables and invocation in `docs/WORKFLOWS.md` and `docs/platform/release.md`.
4. Keep non-blocking by default; surface artifacts for audit.

Validation:

-    Dry-run or build-only job passes with vars disabled; with vars enabled (manual dispatch), jobs execute expected steps.
-    `docs/WORKFLOWS.md` includes the workflow entry and gate mapping.

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
