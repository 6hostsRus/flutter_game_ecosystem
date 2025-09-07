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

-    docs/metrics/in_app_purchase_symbols.json — discovered real plugin symbols
-    docs/metrics/parity_diff_in_app_purchase.json — parity gaps summary

CI triggers:

-    Manual: Run the "semantic-parity" workflow with input enable=true.
-    PR label: Add the label run-semantic-parity to a pull request that touches the paths listed at the top of the workflow; the job will run and upload artifacts.

Matrix support:

-    All specs under tools/parity_spec/\*.json are run in a matrix; add more spec files to include additional plugins.
-    Artifacts are uploaded per package (semantic-parity-<package>). A summary comment with links to artifacts is posted on the PR.

CI note: If the real plugin isn’t present, the job will skip gracefully. To generate artifacts locally, follow the commands above.
