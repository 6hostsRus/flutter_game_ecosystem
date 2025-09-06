# Golden tests

This folder contains widget golden tests for the demo game. Baseline images live in `examples/demo_game/goldens/`.

Tips:

-    Run a single golden:
     flutter test test/goldens/home_screen_golden_test.dart -r expanded
-    Update a baseline image after an intentional UI change:
     flutter test --update-goldens test/goldens/home_screen_golden_test.dart

CI will fail if golden images change without being updated/committed.
