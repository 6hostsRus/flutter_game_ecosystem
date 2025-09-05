# Unified Way Forward — 2025-08-30

> Deprecated: Consolidated into `docs/STACK.md`. Keep this file for historical context until fully removed in a later release.

**State/DI:** **Riverpod** (ProviderScope at root, feature-scoped providers).  
**Routing:** **GoRouter** (declarative, deep-links).  
**Rendering:** **Flame** for action scenes; pure Flutter for shell/menus.  
**Persistence:** **Isar** (fast embedded) or Drift where relational queries help.  
**Analytics:** Central adapter (see `core_services/analytics`) → pluggable sinks (Debug, GA4, Pinpoint).  
**Feature flags:** `--dart-define` + `AppConfig`.  
**Monetization:** Store via `OffersService`; IAP integration later behind same API.  
**Live-ops:** Event model in core; categories query it for boosts/dailies.  
**Testing:** Golden tests for UI; deterministic sims for idle/wave; provider overrides for services.

## Riverpod Patterns

-    Keep services as plain classes + Riverpod providers (easy to mock/override).
-    One source of truth for currency: `walletProvider`.
-    Category UIs read/write wallet + analytics via providers — no globals.

## Folder Shape

```
/packages/core_services     # wallet, offers, analytics (+ providers)
/packages/game_ui           # shared widgets & tokens
/packages/game_scenes       # Flame scenes (platformer, survivor)
/docs/ ...                  # design guides
/examples/demo_game         # integration reference
```

## Optional Add-ons

-    **Persistence (Isar):** use `packages/core_services_isar` (run `build_runner` to generate schemas).
-    **Analytics (Firebase):** use `packages/analytics_firebase_adapter` and override `analyticsProvider`.
-    **Live-Ops:** `liveOpsProvider` supplies time-bounded boosts (e.g., `idle_rate` multiplier).
