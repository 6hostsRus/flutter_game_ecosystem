# AI Task Library (Open Items Only)

Reusable task blueprints that are still active. Completed tasks have been moved into `CHANGELOG.md` under dated sections.

Note: Before executing any task from this library, follow the standard steps in `docs/AI_TASK_CHECKLIST.md`.

## How to use this library

-    Start with the standard execution steps in `docs/AI_TASK_CHECKLIST.md`.
-    To create or extend this library, use the prompt in `docs/AI_TASK_LIBRARY_PROMPT.md` and then update this file accordingly.

---

# Open Task

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
