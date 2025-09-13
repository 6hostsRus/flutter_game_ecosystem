Feature branch strategy: `feat/config-runtime-unify-v1`

This file documents the operating model for the unified feature-branch migration.

-    Canonical branch: `feat/config-runtime-unify-v1` is the canonical working branch for the
     ConfigRuntimeUnify migration. All PoC and incremental package changes land here.

-    PR model: A single open PR (PR #1) points at this branch and is updated as work
     progresses. The PR contains a living `docs/migrations/PR_1_SUMMARY.md` updated by
     commits to the branch and by the automation (developer will paste analyze/test
     outputs per-package).

-    When to split into focused PRs: If reviewers request smaller diffs or a package
     owner requests a separate review, create a focused branch from `feat/config-runtime-unify-v1`
     (e.g., `feat/config-runtime-unify-v1/providers-only`) and open a focused PR for
     that package derived from the feature branch snapshot. Keep the feature branch
     as the source of truth.

-    CI expectations: Each commit to the feature branch should run `melos bootstrap`,
     `melos run analyze`, and a representative `melos run test` matrix. For speed, CI
     may sample test suites but must run full analysis.

-    Documentation artifacts: Always update `docs/migrations/PR_1_SUMMARY.md` and
     `docs/AI_TASK_RECONCILIATION.md` with the status of changes. Include per-package
     analyze/test output snippets for easy reviewer verification.

-    Rollback and revert: Make small, focused commits. If a commit causes CI failure,
     revert the commit and file a blocker issue. Use deprecation shims for compatibility
     when needed.

-    Owner: repo maintainers / release engineers.
