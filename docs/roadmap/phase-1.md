# Phase-1 Roadmap — Ship One Game + Core Pack

Updated: 2025-09-07

Goal

Release a small, polished Endless Runner using v1 modules while establishing reusable packages.

Deliverables

-    game_controls v1 (gesture + virtual stick/button)
-    game_ads v1 (rewarded/interstitial + caps)
-    game_db v1 (local save, versioned)
-    game_characters v1 (player state machine, basic enemy/hazard)
-    game_items v1 (coins, 2–3 powerups)
-    template_endless_runner playable
-    runner_demo hooked to modules

Milestones (pace)

-    Day 1–2: Repo + packages scaffold; controls/characters skeletons; runner scene.
-    Day 3–4: Items & pickups; segment spawner; death/game-over loop.
-    Day 5: Ads wrapper + placements (rewarded retry, interstitial on game-over).
-    Day 6: Save (coins/skins/settings); shop stub.
-    Day 7: Polish, SFX hooks, perf pass; release build + store checklist.

Pacing & Metrics

-    Quality gates: coverage ≥ policy, stub parity ok, route/spec hashes consistent.
-    Perf thresholds: p95 and action counts per perf-metrics workflow.
-    Analytics: minimum event presence in CI.
-    Artifacts: perf JSON, spec hashes, parity artifacts (optional).

Cross-links

-    Workflows: `docs/WORKFLOWS.md`
-    Metrics: `docs/METRICS.md`
