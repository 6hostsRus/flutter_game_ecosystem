# Unified Stack — How to Run Key Workflows

Quick references for running the most relevant CI workflows and their local equivalents.

## Perf Metrics (CI + Local)

-    CI: Workflow “Perf Metrics” (`.github/workflows/perf-metrics.yml`)
     -    Runs a deterministic simulation to generate `packages/services/build/metrics/perf_simulation.json`.
     -    Validates thresholds with `tools/check_perf_metrics.dart` and uploads the artifact.
-    Local (optional):
     -    Generate metrics:
          -    cd packages/services
          -    flutter test test/perf/performance_simulation_test.dart -r expanded
     -    Validate thresholds:
          -    cd ../../
          -    dart run tools/check_perf_metrics.dart --file packages/services/build/metrics/perf_simulation.json --max-p95-us 12000 --min-spends 100 --min-awards 150 --min-purchases 50

## Semantic Parity (Optional Artifacts)

-    CI: Workflow “Auto Update Parity Spec (optional)” (`.github/workflows/auto-update-parity-spec.yml`)
     -    Trigger via workflow_dispatch with input `enable=true`.
     -    Builds symbol map, regenerates `tools/parity_spec/<pkg>.json`, runs parity check, and uploads artifacts.
-    Local (optional):
     -    Build symbol map:
          -    dart run tools/build_symbol_map.dart --package in_app_purchase --out docs/metrics/in_app_purchase_symbols.json
     -    Auto-update spec:
          -    dart run tools/auto_update_parity_spec.dart --package in_app_purchase --symbols docs/metrics/in_app_purchase_symbols.json

Notes:

-    These are additive aids for visibility and guardrails; core gates still run in `ci.yml`.
