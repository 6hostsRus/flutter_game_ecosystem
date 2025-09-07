# Golden Test Guidelines

Golden (visual regression) tests ensure UI changes are deliberate.

## Layout

-    Test files: `examples/demo_game/test/goldens/*_golden_test.dart`
-    Baselines: `examples/demo_game/goldens/*.png`
-    Path convention inside test: `matchesGoldenFile('../../goldens/<name>.png')` (relative from test/goldens directory)

## Adding a Golden

1. Create widget scenario (minimal app wrapper + Provider overrides for state).
2. Run once with `--update-goldens` to create baseline.
3. Commit both test and generated PNG.

## Updating Goldens

Use sparingly—only when intentional UI changes:

```
cd /Users/Learn/Projects/flutter_game_ecosystem/examples/demo_game
flutter test --update-goldens test/goldens
```

Review diff of PNG (GitHub may not render—download and inspect).

## Determinism Checklist

-    Fixed surface size (e.g., 400x800).
-    Avoid system time variance (stub DateTime if dynamic elements added later).
-    Provide deterministic data (wallet balances, item lists).
-    Disable animations if introducing long-running ones (pump settled frames).

## CI

-    Workflow: `golden-guard.yml` runs golden tests on PRs when goldens present.
-    Future: Add image diff artifact on failure.

## Scenarios Roadmap

| Golden           | Purpose                                | Status  |
| ---------------- | -------------------------------------- | ------- |
| home_screen      | Baseline HUD + tabs                    | Added   |
| store_screen     | Store entry state                      | Added   |
| home_screen_rich | Non-zero balances showcase             | Added   |
| upgrades_screen  | Scroll list with locked/unlocked costs | Planned |

## Anti-Patterns

-    Overly dynamic text (timestamps, random numbers).
-    Large canvas sizes without need (slower diffs).
-    Multiple unrelated widgets in one golden (hard to reason about diff cause).

---

Generated via automated task batch (golden docs).
