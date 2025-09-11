# AI Operations

Core operational commands & validation sequence.

## Validation Steps

1. dart pub get (root + touched packages)
2. dart analyze
3. If tests added/changed: dart test --reporter=compact
4. Optional: dart format --output=none --set-exit-if-changed .

## Common Commands

-    /release-candidate <x.y.z>
-    /screenshots ios|android
-    /submit-ios
-    /promote android internal|production [percent]
-    /store sync ios|android
-    /hotfix start <ver>
-    /hotfix release <ver>

## Change Classification Header

Add at top of modified files:

```dart
// change-class: doc|feature|refactor|test|infra
```

## Multi-Step Execution Flow

Enumerate → Plan → Execute sequentially → Validate after each → Summarize.

## Monorepo / Melos helper commands

-    `melos bootstrap` - install and link packages in the monorepo
-    `melos run analyze` - run analyzer across packages
-    `melos run test --scope <pkg>` - run tests for a specific package
-    `melos exec -- <cmd>` - run a shell command across packages

Note: For repo-wide refactors, always run `melos bootstrap` at the repo root before running analysis or tests. Use `--scope` on slow test suites to validate packages incrementally.

## Refactor flow (recommended)

1. Plan: Create a package-level migration plan and present it as numbered options for the owner to pick (e.g., 1. providers-first, 2. examples-first, 3. parallel per-package PRs).
2. Proof-of-concept: Implement a small PoC change in one package (single PR) with tests and `melos bootstrap` validation.
3. Execute: Create per-package PRs following the chosen option; include a short migration README in the first PR describing the full sequence.
4. Validate: For each PR run `melos run analyze --scope <pkg>` and `melos run test --scope <pkg>`; fix issues before merging.
5. Summarize: After merging all PRs, run a full `melos run analyze` and a representative `melos run test` matrix, then update `CHANGELOG.md` and `docs/AI_TASK_RECONCILIATION.md`.
