#!/usr/bin/env bash

set -euo pipefail

state="${1:-}"

if [[ -z "$state" ]]; then
  echo "Usage: $0 [battery|ac|ac-perf]"
  exit 1
fi

set_profile() {
  local profile="$1"
  if command -v powerprofilesctl >/dev/null 2>&1; then
    powerprofilesctl set "$profile"
    return
  fi

  if command -v cpupower >/dev/null 2>&1; then
    if [[ "$profile" == "power-saver" ]]; then
      cpupower frequency-set -g powersave
    elif [[ "$profile" == "performance" ]]; then
      cpupower frequency-set -g performance
    else
      cpupower frequency-set -g schedutil
    fi
    return
  fi

  echo "No supported profile tool found (powerprofilesctl/cpupower)."
  exit 2
}

case "$state" in
  battery)
    set_profile power-saver
    ;;
  ac)
    set_profile balanced
    ;;
  ac-perf)
    set_profile performance
    ;;
  *)
    echo "Unsupported state: $state"
    exit 1
    ;;
esac

echo "Power profile switched for state: $state"
