# Semantic Parity Report

This report compares our local stub API parity spec against symbols discovered in the real plugin.

How to generate locally:

```
cd /Users/Learn/Projects/flutter_game_ecosystem
# Build symbol map (requires the real plugin under packages/<name>/lib or vendored)
dart run tools/build_symbol_map.dart --package in_app_purchase --out docs/metrics/in_app_purchase_symbols.json
# Diff vs our parity spec
dart run tools/diff_parity_vs_real.dart \
  --spec tools/parity_spec/in_app_purchase.json \
  --symbols docs/metrics/in_app_purchase_symbols.json \
  --out docs/metrics/parity_diff_in_app_purchase.json
```

Artifacts:
- docs/metrics/in_app_purchase_symbols.json — discovered real plugin symbols
- docs/metrics/parity_diff_in_app_purchase.json — parity gaps summary

CI note: If the real plugin isn’t present, the builder will produce an empty map; the diff report will show all symbols as missing. Use the Real Plugin Matrix flags to control when to enforce this check.
