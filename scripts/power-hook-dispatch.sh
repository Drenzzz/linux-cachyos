#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SWITCH_SCRIPT="${SCRIPT_DIR}/power-mode-switch.sh"
CONFIG_FILE="/etc/default/custom-kernel-power"

if [[ -r "$CONFIG_FILE" ]]; then
  # shellcheck source=/etc/default/custom-kernel-power
  . "$CONFIG_FILE"
fi

ac_mode="${AC_STATE_MODE:-ac}"

if [[ "$ac_mode" != "ac" && "$ac_mode" != "ac-perf" ]]; then
  echo "Invalid AC_STATE_MODE '$ac_mode' in $CONFIG_FILE" >&2
  exit 2
fi

is_ac_online=0
has_mains_entry=0

for ps in /sys/class/power_supply/*; do
  [[ -d "$ps" ]] || continue
  [[ -r "$ps/type" && -r "$ps/online" ]] || continue

ps_type="$(<"$ps/type")"
  if [[ "$ps_type" == "Mains" ]]; then
    has_mains_entry=1
    if [[ "$(<"$ps/online")" == "1" ]]; then
      is_ac_online=1
      break
    fi
  fi
done

if [[ "$has_mains_entry" == "0" ]]; then
  for ps in /sys/class/power_supply/*; do
    [[ -d "$ps" ]] || continue
    [[ -r "$ps/type" && -r "$ps/online" ]] || continue

    ps_type="$(<"$ps/type")"
    case "$ps_type" in
      USB|USB_C)
        if [[ "$(<"$ps/online")" == "1" ]]; then
          is_ac_online=1
          break
        fi
        ;;
    esac
  done
fi

if [[ "$is_ac_online" == "1" ]]; then
  exec "$SWITCH_SCRIPT" "$ac_mode"
else
  exec "$SWITCH_SCRIPT" battery
fi
