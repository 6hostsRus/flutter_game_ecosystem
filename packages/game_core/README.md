# game_core

Core interfaces and small utilities for the ecosystem (SaveDriver abstraction, AppConfig flags, etc.).

Optional: SharedPreferences SaveDriver

`game_core` provides an abstraction `SaveDriver` and ships an in-memory driver used by tests and demos. A lightweight adapter for `shared_preferences` is included as `SharedPreferencesSaveDriver`.

Example wiring (optional):

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';

final saveDriverProvider = Provider<SaveDriver>((ref) {
  // Default for tests and CI
  return InMemorySaveDriver();
});

// To use SharedPreferences in an app, create the driver asynchronously
// and expose it via an AsyncNotifier or FutureProvider. Example outline:
// final sharedPrefsProvider = FutureProvider<SaveDriver>((ref) async =>
//   await SharedPreferencesSaveDriver.create());
```

When using the FutureProvider/AsyncNotifier approach, consumers should await the provider before reading/writing persistent keys.
