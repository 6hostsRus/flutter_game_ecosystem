# CI-mode goldens (alchemist)

This folder contains CI-mode golden baselines generated for the demo_game
package. CI-mode replaces rendered text with solid blocks so golden tests
remain stable across different OS font renderers.

How to generate CI-mode goldens locally

1. From the `examples/demo_game` package root run:

```bash
flutter test --update-goldens --dart-define=alchemist.platform=ci
```

This will produce `*_ci.png` images in `examples/demo_game/goldens` which
should be committed to the repository.

How to run CI-mode tests locally

```bash
flutter test --dart-define=alchemist.platform=ci
```

On CI, ensure the test step uses the same `--dart-define=alchemist.platform=ci` flag
so the runner compares against the CI-mode golden files.

# Golden tests

This folder contains widget golden tests for the demo game. Baseline images live in `examples/demo_game/goldens/`.

Tips:

-    Run a single golden:
     cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
     flutter test test/goldens/home_screen_golden_test.dart -r expanded
-    Update a baseline image after an intentional UI change:
     cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
     flutter test --update-goldens test/goldens/home_screen_golden_test.dart

CI will fail if golden images change without being updated/committed.
