# Coding Standards

Updated: 2025-09-07

Scope

-    These standards guide code reviews and CI gates across packages and examples.
-    Reconciled from `architecture/coding-standards.md` and augmented with current tooling and docs.

Linting & Language

-    Null-safety everywhere; no legacy non-nullable code.
-    Adopt repo lints: see `analysis_options.yaml` (flutter_lints + very_good_analysis where applicable).
-    Prefer small, noun-based public classes; verbs as methods; avoid leaking engine-specific types outside adapters.

-    Use the project-recommended helpers for common analyzer patterns instead of
     inline ignore comments. For example, prefer `unawaited(...)` to intentionally
     discard a Future rather than adding `// ignore: unawaited_futures` on the call.
-    Recommended sources: `package:pedantic` or `package:async` which provide
     `unawaited(...)`. Add as a dependency where runtime code needs it.
-    Prefer `const` for compile-time constant values (including local variables)
     to satisfy lints such as `prefer_const_declarations`. Use `const` where the
     initializer is a compile-time constant.
-    Avoid broad inline analyzer ignores in production code; use them sparingly
     and document the reason in a nearby comment when necessary.

Design Conventions

-    Events: prefer Stream or a lightweight bus; keep UI decoupled from simulation.
-    Time: pass `Duration dt` explicitly to simulation; avoid `DateTime.now()` in core logic.
-    Serialization: use `json_serializable` for DTOs/configs; keep wire models separate from domain where useful.

Testing Strategy

-    Unit tests for logic (fast, deterministic).
-    Golden tests for widgets (stable Keys, deterministic theme/media, baselines in repo).
-    Integration tests for ad gates, save/load, and flows spanning services.
-    Performance checks: simulation harness + threshold validation in CI.
-    Analytics: contract tests assert event names/params and minimum presence in CI.

Commits & PRs

-    Conventional commits; concise, scoped messages (e.g., `feat`, `fix`, `docs`, `ci`, `chore`).
-    Update docs and badges when behavior/metrics/workflows change.

Evaluation Checklist (apply in reviews)

-    Clarity: public API and data shapes documented or self-explanatory.
-    Tests: happy path + 1–2 edges; perf/analytics where applicable; goldens updated safely.
-    Gates: manifest, parity, coverage, route/spec, perf thresholds pass.
-    Docs: links and references updated (README, Workflows, Metrics, relevant guides).
-    Risk: feature flags or fallbacks for platform/plugin variability.

References

-    `docs/WORKFLOWS.md` (gates & automation)
-    `docs/METRICS.md` (badges & endpoints)
-    `docs/AI_TASK_CHECKLIST.md` (per-task execution)
