# Flutter Game Ecosystem — V1 Docs

<!-- Badges -->
<p>
	<a href="docs/METRICS.md">
		<img alt="Coverage" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/coverage.json" />
		<img alt="Packages" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/packages.json" />
		<img alt="Stub parity" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/stub_parity.json" />
		<img alt="Package warnings" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/package_warnings.json" />
	</a>
</p>

<!-- AUTO:README_PACKAGE_COUNT -->Package count: 11<!-- END -->
<!-- AUTO:README_COVERAGE -->Coverage: 56.9%<!-- END -->
<!-- AUTO:README_STUB_PARITY -->Stub parity: OK<!-- END -->
<!-- AUTO:README_PACKAGE_STATUS_WARNINGS -->Package status warnings: 0<!-- END -->

This package contains first‑pass (v1) documents to bootstrap a reusable, modular game ecosystem in Dart/Flutter,
optimized for rapid reskinning and fast iteration.

**Scope of v1**

-    Core libraries: Characters, Items, Controls, Ads, Database
-    Game templates: Endless Runner, Top‑Down Shooter, Match‑3, Physics Sandbox
-    Monetization loop overview
-    Phase‑1 delivery plan (ship one simple game + foundational libs)

> Philosophy: **Build once, reuse everywhere.** Prefer composable modules with clean APIs, no game‑specific logic in core.

---

## AI Development Instructions

See **`ai_instructions.md`** for how the AI should collaborate on this repo (deliverable style, workflows, release commands, and quality gates).

Quick links:

-    Coding Standards: `docs/CODING_STANDARDS.md`
-    Monetization: `docs/monetization/overview.md` • `docs/monetization/testing.md`
-    Platform Guide: `docs/platform/index.md`
-    Roadmap (Phase 1): `docs/roadmap/phase-1.md`

## Automation & CI Workflows

See **`docs/WORKFLOWS.md`** for an overview of all GitHub Actions (CI, metrics, releases, policy, golden tests).

Quick starts for key runs: see **`README_unified_stack.md`** (Perf Metrics and Semantic Parity how-to, with local equivalents).

## Golden Images

Visual regression tests live under `examples/demo_game/test/goldens/` with baselines in `examples/demo_game/goldens/`. Update by running:
`cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game && flutter test --update-goldens test/goldens`.
See `docs/GOLDENS.md` for guidelines.

## Spec Governance

Contract & spec evolution is tracked via hash snapshots:

-    Route registry spec: `tools/route_spec/route_registry.json` (validated in CI)
-    Parity spec & related sources hashed in `docs/SPEC_HASHES.md`

Run locally:

```
dart run tools/check_route_registry.dart
dart run tools/spec_hashes.dart --write
```

## Manifest Drift Hook

Enable local pre-commit protection against manifest drift:

```
chmod +x tools/hooks/pre-commit.manifest
ln -sf ../../tools/hooks/pre-commit.manifest .git/hooks/pre-commit
```

The hook blocks commits if new packages are added or removed without updating `packages/manifest.yaml` and prints YAML snippets to paste.

<!-- AUTO:README_TASK_VISIBILITY -->Open checklist items: 95 (app_store: 16, meta_release: 25, play_store: 18, release_train: 36)<!-- END -->

<!-- AUTO:README_STACK_GEN -->Stack consolidated: 2025-09-05T23:28:41.086052Z<!-- END -->

<!-- AUTO:README_RELEASE_GATES -->Gates: 11/11 (mandatory: 8/8)<!-- END -->

## Real Plugin Matrix

See `docs/REAL_PLUGIN_MATRIX.md` for the feature-flag scaffold that will gate switching to real plugins (IAP/Ads/Analytics) per platform, with `--dart-define` overrides.
