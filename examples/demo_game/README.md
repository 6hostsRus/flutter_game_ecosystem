# Demo Game

Date: 2025-08-30

A minimal Flutter app showing the common shell (bottom nav), HUD, store sheet, upgrades list, and quests screen using `packages/game_ui`.

This example also demonstrates using `package:game_core` APIs (AppConfig flags, RNG, etc.) and optional feature-gated demos:

-    Match-3 demo (flag: `DEMO_MATCH_BUTTON=true` with `FEATURE_MATCH=true`)
-    Survivor HUD demo (always visible to keep goldens stable)
-    Idle ECS demo (flag: `DEMO_IDLE_BUTTON=true` with `FEATURE_IDLE=true`)

## Run

```
cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
flutter pub get
flutter run
```

### Enable Idle demo button

To show the Idle demo button in the home screen, pass both the feature flag and the demo gate at runtime using dart-define. From the repo root run:

```bash
flutter run --dart-define=FEATURE_IDLE=true --dart-define=DEMO_IDLE_BUTTON=true
```

If you only set `FEATURE_IDLE` but not `DEMO_IDLE_BUTTON`, the Idle demo button will remain hidden. Both must be true to reveal the demo button.

Optional: Persisted demo state

The demo app uses `packages/game_core` for its SaveDriver abstraction. You can wire a `SharedPreferencesSaveDriver` to persist demo state. Example provider wiring (optional):

```dart
// inside your app startup or a provider module
import 'package:game_core/game_core.dart';

final saveDriverProvider = Provider<SaveDriver>((ref) {
  // For tests or simplicity, the default is InMemorySaveDriver.
  // To use SharedPreferences in the running demo app, create and return
  // a SharedPreferencesSaveDriver instance:
  // return await SharedPreferencesSaveDriver.create();
  return InMemorySaveDriver();
});
```

If you want persistent demo state in the running app, replace `InMemorySaveDriver()` with the async-created `SharedPreferencesSaveDriver.create()` and adapt provider wiring to an AsyncNotifier or similar so initialization can be awaited.

---

## Optional: Enable Isar + Firebase in the demo

### Isar

```
# in /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game/pubspec.yaml, add
dependencies:
  core_services_isar:
    path: ../../packages/core_services_isar
# then
cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
flutter pub get
dart run build_runner build -d
```

### Firebase Analytics

```
# in examples/demo_game/pubspec.yaml, add
dependencies:
  analytics_firebase_adapter:
    path: ../../packages/analytics_firebase_adapter
# then configure Firebase (Android/iOS) before running.
```
