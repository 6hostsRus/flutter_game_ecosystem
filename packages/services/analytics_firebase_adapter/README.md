
# analytics_firebase_adapter

<!-- Badges -->
<p>
  <a href="https://github.com/6hostsRus/flutter_game_ecosystem/blob/main/docs/METRICS.md">
    <img alt="Coverage (analytics_firebase_adapter)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/coverage_analytics_firebase_adapter.json" />
    <img alt="Packages" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/packages.json" />
    <img alt="Stub parity" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/stub_parity.json" />
  <img alt="Analytics (analytics_firebase_adapter)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/analytics_analytics_firebase_adapter.json" />
  <img alt="Pkg warnings (analytics_firebase_adapter)" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/6hostsRus/flutter_game_ecosystem/main/docs/badges/pkg_warn_analytics_firebase_adapter.json" />
  </a>
</p>
Date: 2025-08-30

Plug-in adapter to route `AnalyticsSink` events to **Firebase Analytics**.

## Setup
1) Add package:
```yaml
dependencies:
  analytics_firebase_adapter:
    path: ../analytics_firebase_adapter
```
2) Configure Firebase (iOS/Android) by adding app files per Firebase docs.
3) Provide the sink:
```dart
final sink = await ref.read(analyticsFirebaseProvider.future);
ref.onDispose(() => null); // usual provider lifecycle
```
4) Swap providers:
```dart
// override analyticsProvider at app root:
return ProviderScope(
  overrides: [
    analyticsProvider.overrideWithValue(await ref.read(analyticsFirebaseProvider.future)),
  ],
  child: const App(),
);
```
