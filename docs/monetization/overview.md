# Monetization Overview

Updated: 2025-09-07

This document reconciles `monetization/monetization.md` with current modules, tests, and CI.

Pillars

-    Rewarded video aligned to player pain (revive/retry/extra moves).
-    Interstitials with caps (cooldowns, first-session deferral).
-    Cosmetics/IAP (stubbed, adapter-first) for future-proofing.

Controls & Experimentation

-    Remote flags per placement (enable, cooldown, frequency caps).
-    A/B toggles (retry vs. revive; N runs between interstitials).

Compliance

-    Platform privacy dialogs, age gating for personalized ads.

Targets

-    Runner: rewarded retry
-    Shooter: rewarded revive
-    Match-3: rewarded +5 moves

Cross-links

-    Testing: `docs/monetization/testing.md`
-    Workflows: `docs/WORKFLOWS.md` (golden-guard, analytics, perf-metrics)
-    Packages: adapters and services in `packages/services`
