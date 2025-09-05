# Coverage Policy & Ratcheting

This repository enforces a minimum line coverage threshold stored in `tools/coverage_policy.yaml`.

## File Structure

```
min_coverage_pct: 28.0
last_updated: 2025-09-05T00:00:00Z
```

Fields:

-    `min_coverage_pct`: Current enforced floor (one decimal place precision).
-    `last_updated`: UTC timestamp when the floor last increased.

## Enforcement

`tools/quality_gates.dart` reads the policy (unless overridden via `COVERAGE_MIN` env) and fails CI if merged coverage (from `coverage/lcov.info`) is below the floor.

## Ratcheting Logic

Implemented by `dart run tools/coverage_ratchet.dart`:

1. Parse current floor from policy file.
2. Compute actual merged coverage.
3. If `actual >= floor + 1.0`, bump the floor to `floor(actual - 0.1)` (one decimal) so there is a small headroom buffer.
4. Update `last_updated` timestamp.
5. Exit 0 (idempotent). Never lowers the threshold.

## Usage (Local)

After adding new tests and regenerating coverage:

```
./tools/run_all_tests.sh
dart run tools/coverage_ratchet.dart
git add tools/coverage_policy.yaml
```

Open a PR with the message: "chore(coverage): ratchet threshold to X.Y%".

## CI Integration (Planned)

Add a post-test step in the metrics or CI workflow to run the ratchet script. If the file changes, commit via a bot or surface a PR suggestion.

## Why 1% Increment Guard?

Prevents churn from small statistical fluctuations. Only meaningful coverage gains (≥1%) raise the floor.

## Manual Adjustments

Lowering `min_coverage_pct` is discouraged and should be accompanied by justification in the PR description.

---

Generated via AI task: CoverageThresholdRatcheting (P2).
