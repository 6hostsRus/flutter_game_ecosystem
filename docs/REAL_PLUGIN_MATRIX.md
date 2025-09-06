# Real Plugin Matrix — Feature Flag Scaffold

Purpose: prepare the wiring to flip from stubbed to real store/ads/analytics plugins per-platform via flags, with optional compile-time env overrides.

Sources:

-    Flags loader: `packages/providers/lib/flags/flag_provider.dart`
-    Evaluator: `packages/services/lib/flags/flag_evaluator.dart`
-    Matrix: `packages/providers/lib/flags/real_plugin_matrix.dart`

Flag keys:

-    Global keys: `real_iap`, `real_ads`, `real_analytics`
-    Platform-specific overrides: `real_iap_ios`, `real_iap_android`, `real_ads_ios`, etc.
     -    Platform-specific flags take precedence over global.

Env overrides (compile-time):

-    `--dart-define=USE_REAL_IAP=true`
-    `--dart-define=USE_REAL_ADS=true`
-    `--dart-define=USE_REAL_ANALYTICS=true`

Providers:

-    `realPluginMatrixProvider` → `RealPluginMatrix{iap, ads, analytics}`
-    `useRealIapFromMatrixProvider` → `bool` (monetization wiring)
-    `useRealAdsFromMatrixProvider` → `bool`
-    `useRealAnalyticsFromMatrixProvider` → `bool`

Usage sketch (app boot):

```dart
final useRealIap = ref.watch(useRealIapFromMatrixProvider).maybeWhen(
  data: (v) => v,
  orElse: () => false,
);
```

Example flags JSON (`examples/demo_game/assets/flags.local.json`):

```json
{
     "real_iap_android": false,
     "real_iap_ios": false,
     "real_ads": false,
     "real_analytics": false
}
```

Notes:

-    This is a scaffold only; adapters still use stubs by default.
-    Monetization provider now consults the IAP toggle and falls back to mock while flags resolve or if disabled.
-    When integrating real Ads/Analytics adapters, consult the corresponding toggles to pick real vs. debug sinks.
