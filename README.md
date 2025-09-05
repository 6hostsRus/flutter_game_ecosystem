# Flutter Game Ecosystem — V1 Docs

<!-- Badges -->
<p>
	<a href="docs/METRICS.md">
		<img alt="Coverage" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/coverage.json" />
	</a>
</p>

<!-- AUTO:README_PACKAGE_COUNT -->Package count: 11<!-- END -->
<!-- AUTO:README_COVERAGE -->Coverage: 28.6%<!-- END -->
<!-- AUTO:README_STUB_PARITY -->Stub parity: (run metrics)<!-- END -->

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

## Automation & CI Workflows

See **`docs/WORKFLOWS.md`** for an overview of all GitHub Actions (CI, metrics, releases, policy, golden tests).

## Golden Images

Visual regression tests live under `examples/demo_game/test/goldens/` with baselines in `examples/demo_game/goldens/`. Update by running:
`flutter test --update-goldens examples/demo_game/test/goldens`.
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
