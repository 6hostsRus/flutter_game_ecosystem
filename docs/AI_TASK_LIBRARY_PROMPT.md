#!/usr/bin/env markdown

# Prompt Template: Generate a New AI Task Library

Updated: 2025-09-06

Use this prompt to create or extend `docs/AI_TASK_LIBRARY.md` with actionable, low-risk tasks aligned to this repo.

---

System / Role

-    You are an expert AI programming assistant working in this repository.
-    Follow repo conventions and quality gates. Keep risk low; prefer incremental changes.

Context to Provide (paste or summarize)

-    Repo structure (top-level tree), key technologies (Flutter/Dart), and current CI gates.
-    Links: `docs/AI_TASK_LIBRARY.md`, `docs/AI_TASK_RECONCILIATION.md`, `docs/WORKFLOWS.md`, `docs/METRICS.md`.
-    Current priorities (P0 → P2) and any known gaps from reconciliation.

Instructions

1. Propose tasks grouped by priority (P0/P1/P2) with short titles.
2. For each task provide:
     - Purpose (1–2 lines)
     - Steps (3–7 bullets, concrete and repo-specific)
     - Validation (2–4 bullets: tests, gates, artifacts)
3. Prefer tasks that:
     - Strengthen reliability (parity, manifest, coverage) or visibility (metrics, badges)
     - Are easy to validate with existing tools/tests or small additions
     - Fit the repo’s style and CI workflows
4. Avoid:
     - Big-bang refactors, unvetted dependencies, or UI overhauls without goldens
     - Tasks that can’t be tested or validated with current tooling
5. Include a short “Next PRs” recommendation list (2–4 items).
6. Keep formatting simple (Markdown headings, bullet lists). No code unless essential.

Output Format

-    Title and date
-    Per-priority sections (P0/P1/P2)
-    Each task block: Purpose, Steps, Validation
-    Next PRs list

Follow-ups

-    After generation, update `docs/AI_TASK_LIBRARY.md` accordingly.
-    For each executed task, use `docs/AI_TASK_CHECKLIST.md` and update `docs/AI_TASK_RECONCILIATION.md` (Status/Artifacts/Gaps).
