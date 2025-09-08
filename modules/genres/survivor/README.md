# Survivor module

This module provides a small run-state model used by survivor-like demos.

-    `lib/src/run_state.dart` contains `SurvivorRunState` with tick progression, scaling helpers, and JSON (de)serialization.
-    Add tests under `test/` to validate tick progression and edge cases (death, wave increments).

Suggested tasks:

-    Add a small demo scene that consumes `SurvivorRunState` and drives a HUD for health/wave/time.
-    Add sample fixtures and a serializer for save/restore.
