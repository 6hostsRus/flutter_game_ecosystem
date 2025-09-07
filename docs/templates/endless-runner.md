# Template: Endless Runner (V1)

## Core Loop

-    Tap/press to jump/dash, avoid obstacles, collect coins, progress speed.
-    Procedural segment stitching with difficulty ramp.

## Systems Used

-    Characters (player + hazards), Items (coins/powerups), Controls (tap/hold), Ads, DB.

## Scenes

-    `MainMenu` → `Game` → `GameOver` → `Shop`

## Data

-    JSON: segment definitions, spawn weights, speed curve, shop items/skins.

## Monetization Hooks

-    Rewarded **retry** after death
-    Interstitial every N runs
-    Cosmetic skin IAPs (v1 stub)

## KPIs to Track

-    D1 retention proxy: % who use rewarded retry
-    Avg runs/session, coins/minute

## Deliverables (v1)

-    Playable lane runner with 1 biome
-    3 powerups (shield, magnet, double‑coins)
-    Shop UI stub + skin swap
