# Environment Feature Flags

Use compile-time environment flags to toggle features and enable tree-shaking in release builds.

## AppConfig (game_core)

Import from game_core:

-    `AppConfig.defaults` — const defaults (all true)
-    `AppConfig.fromEnvironment()` — reads `--dart-define` values via `bool.fromEnvironment`
-    `copyWith(...)` — override specific flags at runtime for tests/dev

Example:

```dart
import 'package:game_core/game_core.dart';

final config = AppConfig.fromEnvironment();
if (config.featureIdle) {
  // enable idle mode routes, UI, etc.
}
```

## Passing flags

Flutter run:

```sh
flutter run --dart-define=FEATURE_IDLE=false --dart-define=FEATURE_PLATFORMER=true
```

Flutter test:

```sh
flutter test --dart-define=FEATURE_IDLE=false
```

CI (Melos): set `--dart-define` in each package invocation or configure a wrapper script.

## Notes

-    Flags are compile-time. In release, unused code paths can be tree-shaken.
-    Defaults are true if a flag is missing.
-    Available flags: FEATURE_IDLE, FEATURE_PLATFORMER, FEATURE_RPG, FEATURE_MATCH, FEATURE_CCG, FEATURE_SURVIVOR.
