# Demo Game

Date: 2025-08-30

A minimal Flutter app showing the common shell (bottom nav), HUD, store sheet, upgrades list, and quests screen using `packages/game_ui`.

## Run

```
cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
flutter pub get
flutter run
```

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
