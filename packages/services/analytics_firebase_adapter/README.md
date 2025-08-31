
# analytics_firebase_adapter
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
