# AI Instructions

Version: 2025-09-04  
Source of truth for automated AI agent operations in this repository.

## 0. Scope
These instructions govern repository‑local AI actions (code scaffolding, refactors, doc maintenance, stub parity, test generation). Do not invent architecture or external services beyond what is declared in repo files.

## 1. Operating Principles
- Minimal, incremental, reversible changes per task.
- Never delete user content without explicit deprecation note.
- Prefer refactor + red/green tests before broad changes.
- Keep PR-size small (logical unit).
- Reflect every structural change in manifest or docs.
- Validate after each change: `dart analyze` and (if tests touched) `dart test --reporter=compact`.

## 2. High-Priority Task Sequence (Run in Order)
1. Package Manifest (create/maintain packages/manifest.yaml).
2. Stack Doc Consolidation (create docs/STACK.md; deprecate duplicates).
3. Monetization Hardening (factory, tests, fake, feature flag).
4. Stub Parity Guard (script + CI hook).
5. Metrics Scaffolding (docs/METRICS.md placeholders).
6. AI Doc Modularization (split instructions into AI_* files if directed).

Stop if any step introduces analyzer or test failures.

## 3. Canonical Tasks (Action Recipes)
Each task below: Preconditions → Actions → Validation → Output.

### Task: CreateOrUpdateManifest
Pre: None (file may or may not exist).  
Actions:
1. If missing, create `packages/manifest.yaml` with schema_version, last_updated, packages map.
2. If exists, merge (preserve unknown keys).
3. Sort packages alphabetically.
Validation: YAML parses; all listed paths exist.  
Output: Updated `packages/manifest.yaml`.

### Task: ConsolidateStackDocs
Pre: `architecture/overview.md` OR `README_unified_stack.md` present.  
Actions:
1. Create/update `docs/STACK.md` merging architecture, layers, extension points.
2. Insert deprecation banner at top of superseded docs pointing to STACK.md (do not delete).
Validation: All intra-doc links resolve (grep for broken relative links).  
Output: `docs/STACK.md` + modified legacy docs.

### Task: HardenMonetizationAdapter
Pre: Adapter file exists.  
Actions:
1. Add factory `monetization_gateway_factory.dart`.
2. Add tests covering purchase state mapping.
3. Add fake in_app_purchase implementation under `test/`.
4. Introduce `USE_REAL_IAP` bool.fromEnvironment flag (placeholder until real plugin).
Validation: Tests pass; no analyzer warnings.  
Output: Factory + tests + fake + passing CI.

### Task: AddStubParityCheck
Pre: Local stub package exists.  
Actions:
1. Add `tools/check_stub_parity.dart`.
2. Ensure it asserts presence of critical symbols.
3. Add CI workflow step (if not present) invoking script.
Validation: Script exits 0 locally.  
Output: Script + CI change.

### Task: ScaffoldMetrics
Pre: None.  
Actions:
1. Create `docs/METRICS.md` with AUTO markers.
2. (Optional) Add placeholder badge references in root README.
Validation: File exists; markers unique.  
Output: `docs/METRICS.md`.

### Task: ModularizeAIInstructions
Pre: This file large (>400 lines) or instructed by user.  
Actions:
1. Split into: `docs/AI_OPERATIONS.md`, `docs/AI_POLICY.md`, `docs/AI_TASK_LIBRARY.md`.
2. Replace this file body with index + version + pointers.
Validation: All new files exist; links valid.  
Output: Updated `ai_instructions.md` + new docs.

## 4. File Editing Rules
- Use 4 backtick code fences with language id.
- Always include `// filepath:` comment at top of code blocks for new/modified files.
- When modifying existing file: show only changed region bracketed by `// ...existing code...` markers (retain necessary context).
- Never collapse multiple unrelated changes into one block.

## 5. Validation Commands
Run after each change set:
1. `dart pub get` (root & affected packages).
2. `dart analyze`.
3. If tests modified/added: `dart test --reporter=compact`.
4. Optional: `dart format --output=none --set-exit-if-changed .` (fail if formatting drift).

Report only new issues introduced (diff vs previous run).

## 6. Stub Parity Policy
- Every stubbed external integration must have:
  - Header comment: Original package name + last verified upstream version.
  - Parity script entry (symbol list).
  - TODO tag with date for next verification.
- Failing parity blocks merge.

## 7. Manifest Rules
`packages/manifest.yaml` fields per package:
- path: relative path
- role: one of [core_services, example, tool, plugin, test_support, experimental]
- status: [experimental, alpha, beta, stable, deprecated]
- owner: team or alias
- domain: principal domain (e.g., monetization, gameplay, infra)
- notes: short free text

Update `last_updated` ISO date on each modification.

## 8. Metrics Update Hooks (Placeholders)
Markers in docs/METRICS.md:
- <!-- AUTO:PACKAGE_COUNT -->
- <!-- AUTO:COVERAGE -->
- <!-- AUTO:STUB_PARITY -->
Automation replaces inner text only.

## 9. Test Authoring Guidelines
- One logical behavior per test.
- Use fake/spy objects in `test/<domain>/fake_*.dart`.
- Prefer explicit asserts on mapped enums and error codes.
- Avoid sleeps > 50ms; prefer `pumpEventQueue` if needed.

## 10. Naming Conventions
- Ports: `<domain>_port.dart`
- Adapters: `<integration>_adapter.dart`
- Factories: `<domain>_factory.dart`
- Tests: mirror lib path under test/
- Fakes: `fake_<dependency>.dart`

## 11. Change Classification
Add comment header in modified files:
`// change-class: doc|feature|refactor|test|infra`
Used for automated labeling.

## 12. Prohibited Actions
- Introducing new runtime dependencies without manifest update.
- Global renames without explicit user confirmation.
- Deleting deprecated docs before at least one release cycle notes them.

## 13. Standard Commit Message Template
`feat(monetization): add factory for gateway selection`
Scopes: monetization, docs, infra, ai, tests, build, refactor, chore.

## 14. Quick Command Snippets (Mac)
Analyze: `dart analyze`
Tests: `dart test --reporter=compact`
Specific package: `dart test -p chrome`
Format check: `dart format --output=none --set-exit-if-changed .`

## 15. Execution Flow for Multi-Step Request
If user asks for combined tasks:
1. Enumerate tasks.
2. Confirm order.
3. Execute tasks sequentially (apply + validate each).
4. Summarize outcomes; stop on first failure.

## 16. Safety & Reversion
Before multi-file change, output planned file list.
If user cancels, abort without partial edits.

## 17. Example Interaction (Condensed)
User: "Add parity check."
Agent:
1. Create tools/check_stub_parity.dart (code block).
2. Modify workflow file (code block).
3. Run validation commands; report results.

## 18. Escalation
If ambiguity: ask user a single clarifying question; do not proceed speculatively.

---

End