#!/usr/bin/env bash
set -euo pipefail

# Kill all running 'dart' and 'flutter' processes safely.
# Usage: tools/kill_dart_flutter.sh [-y] [--remove-lock]
#   -y             non-interactive (assume yes to kill)
#   --remove-lock  after killing, remove Flutter SDK lockfile if present (only if no flutter/dart processes remain)

FORCE=no
REMOVE_LOCK=no

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes)
      FORCE=yes
      shift
      ;;
    --remove-lock)
      REMOVE_LOCK=yes
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [-y] [--remove-lock]"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      echo "Usage: $0 [-y] [--remove-lock]"
      exit 2
      ;;
  esac
done

# Find candidate pids (exclude this script's shell process)
PIDS=()
while IFS= read -r pid; do
  # ignore empty
  [[ -z "$pid" ]] && continue
  PIDS+=("$pid")
done < <(pgrep -f "(dart|flutter)" || true)

# Remove our own shell pid if present
SELF_PID=$$
for i in "${!PIDS[@]}"; do
  if [[ "${PIDS[$i]}" == "$SELF_PID" ]]; then
    unset 'PIDS[$i]'
  fi
done

if [ ${#PIDS[@]} -eq 0 ]; then
  echo "No running dart/flutter processes found.";
else
  echo "Found dart/flutter processes:";
  ps -o pid,user,comm,args -p "${PIDS[*]}" || ps -o pid,user,comm,args

  if [ "$FORCE" != "yes" ]; then
    read -r -p "Kill these processes? [y/N]: " resp
    resp=${resp:-N}
    if [[ ! "$resp" =~ ^[Yy] ]]; then
      echo "Aborting; no processes killed."
      exit 0
    fi
  fi

  echo "Sending SIGTERM to: ${PIDS[*]}"
  kill ${PIDS[*]} || true

  # wait up to 5s for processes to exit
  for i in {1..5}; do
    sleep 1
    STILL_RUNNING=()
    while IFS= read -r pid; do
      [[ -z "$pid" ]] && continue
      STILL_RUNNING+=("$pid")
    done < <(pgrep -f "(dart|flutter)" || true)
    # filter out our own pid
    for j in "${!STILL_RUNNING[@]}"; do
      if [[ "${STILL_RUNNING[$j]}" == "$SELF_PID" ]]; then
        unset 'STILL_RUNNING[$j]'
      fi
    done
    if [ ${#STILL_RUNNING[@]} -eq 0 ]; then
      echo "All processes terminated gracefully.";
      break
    fi
    echo "Waiting for processes to exit... (${i}/5)"
  done

  # Force kill if still present
  STILL_RUNNING=()
  while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    STILL_RUNNING+=("$pid")
  done < <(pgrep -f "(dart|flutter)" || true)
  for j in "${!STILL_RUNNING[@]}"; do
    if [[ "${STILL_RUNNING[$j]}" == "$SELF_PID" ]]; then
      unset 'STILL_RUNNING[$j]'
    fi
  done
  if [ ${#STILL_RUNNING[@]} -ne 0 ]; then
    echo "Processes still running after SIGTERM: ${STILL_RUNNING[*]}"
    if [ "$FORCE" != "yes" ]; then
      read -r -p "Send SIGKILL (force) to remaining processes? [y/N]: " resp2
      resp2=${resp2:-N}
      if [[ ! "$resp2" =~ ^[Yy] ]]; then
        echo "Leaving remaining processes running.";
      else
        echo "Sending SIGKILL to: ${STILL_RUNNING[*]}"
        kill -9 ${STILL_RUNNING[*]} || true
      fi
    else
      echo "Force flag set; sending SIGKILL to: ${STILL_RUNNING[*]}"
      kill -9 ${STILL_RUNNING[*]} || true
    fi
  fi
fi

# Optionally remove the Flutter SDK lockfile if requested and no flutter/dart processes remain
if [ "$REMOVE_LOCK" = "yes" ]; then
  # Re-check no flutter/dart processes
  FINAL_PIDS=()
  while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    FINAL_PIDS+=("$pid")
  done < <(pgrep -f "(dart|flutter)" || true)
  for k in "${!FINAL_PIDS[@]}"; do
    if [[ "${FINAL_PIDS[$k]}" == "$SELF_PID" ]]; then
      unset 'FINAL_PIDS[$k]'
    fi
  done

  if [ ${#FINAL_PIDS[@]} -ne 0 ]; then
    echo "Not removing lockfile: dart/flutter processes still running: ${FINAL_PIDS[*]}";
    exit 0
  fi

  # Find flutter binary
  if command -v flutter >/dev/null 2>&1; then
    FLUTTER_BIN="$(command -v flutter)"
    FLUTTER_ROOT="$(dirname "$(dirname "$FLUTTER_BIN")")"
    LOCKFILE="$FLUTTER_ROOT/bin/cache/lockfile"
    if [ -f "$LOCKFILE" ]; then
      echo "Found Flutter lockfile: $LOCKFILE"
      if [ "$FORCE" != "yes" ]; then
        read -r -p "Remove lockfile $LOCKFILE ? [y/N]: " r
        r=${r:-N}
        if [[ ! "$r" =~ ^[Yy] ]]; then
          echo "Not removing lockfile.";
          exit 0
        fi
      fi
      rm -f "$LOCKFILE" && echo "Removed $LOCKFILE"
    else
      echo "No Flutter lockfile found at $LOCKFILE"
    fi
  else
    echo "flutter not found on PATH; cannot locate SDK lockfile.";
  fi
fi

exit 0
