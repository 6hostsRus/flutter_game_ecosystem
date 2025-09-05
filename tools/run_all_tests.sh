#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)
cd "$ROOT_DIR"

PACKAGES=()
while IFS= read -r -d '' dir; do
  PACKAGES+=("$dir")
done < <(find packages -maxdepth 6 -name pubspec.yaml -print0 | xargs -0 -n1 dirname | sort -u | grep -v "/build/")

echo "Discovered packages:" "${PACKAGES[@]}"
MISSING_TESTS=()
for pkg in "${PACKAGES[@]}"; do
  echo "--- Testing $pkg";
  pushd "$pkg" >/dev/null
  if [ ! -d test ] || [ -z "$(find test -name '*_test.dart' 2>/dev/null)" ]; then
    echo "(no tests found)";
    MISSING_TESTS+=("$pkg")
  else
    if grep -q "flutter:" pubspec.yaml; then
      flutter test --coverage || { echo "Tests failed in $pkg"; exit 1; }
    else
      dart test --coverage=coverage || { echo "Tests failed in $pkg"; exit 1; }
    fi
  fi
  popd >/dev/null
done

if [ ${#MISSING_TESTS[@]} -gt 0 ]; then
  echo "Packages missing tests:" "${MISSING_TESTS[@]}"
  exit 1
fi

## Aggregate analytics events from all packages (if any produced during tests)
mkdir -p build/metrics
AGG_LOG="build/metrics/analytics_events.ndjson"
> "$AGG_LOG" || true
while IFS= read -r -d '' f; do
  cat "$f" >> "$AGG_LOG" || true
done < <(find packages -path '*/build/metrics/analytics_events.ndjson' -print0 2>/dev/null || true)
# Remove if empty so metrics script can still treat missing vs zero meaningfully
[ -s "$AGG_LOG" ] || rm -f "$AGG_LOG"

dart run tools/merge_coverage.dart

# Optional coverage threshold gate (initial 40%).
if [ -f coverage/lcov.info ]; then
  TOTAL_LINES=$(grep -c '^DA:' coverage/lcov.info || true)
  HIT_LINES=$(grep '^DA:' coverage/lcov.info | grep -v ',0$' | wc -l | tr -d ' ')
  if [ "$TOTAL_LINES" -gt 0 ]; then
    PCT=$(python3 - <<EOF
total=$TOTAL_LINES
hit=$HIT_LINES
print(round(hit/total*100,1))
EOF
)
    echo "Aggregate coverage: $PCT% (lines: $HIT_LINES/$TOTAL_LINES)"
  THRESH=25.0
    python3 - <<EOF
pct=$PCT
thresh=$THRESH
import sys
sys.exit(0 if pct >= thresh else 1)
EOF
    if [ $? -ne 0 ]; then
      echo "Coverage $PCT% below threshold $THRESH%" >&2
      exit 1
    fi
  fi
fi

echo "All package tests complete."
