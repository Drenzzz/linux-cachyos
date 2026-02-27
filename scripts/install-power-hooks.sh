#!/usr/bin/env bash

set -euo pipefail

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: sudo $0 [--ac-mode ac|ac-perf] [--with-acpid]"
  exit 0
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo $0 [--ac-mode ac|ac-perf] [--with-acpid]"
  exit 1
fi

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_DIR="/usr/local/libexec/custom-kernel"
UDEV_RULE_DIR="/etc/udev/rules.d"
ACPID_EVENT_DIR="/etc/acpi/events"
DEFAULTS_FILE="/etc/default/custom-kernel-power"

ac_mode="ac"
with_acpid=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ac-mode)
      ac_mode="${2:-}"
      shift 2
      ;;
    --with-acpid)
      with_acpid=1
      shift
      ;;
    -h|--help)
      echo "Usage: sudo $0 [--ac-mode ac|ac-perf] [--with-acpid]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ "$ac_mode" != "ac" && "$ac_mode" != "ac-perf" ]]; then
  echo "Invalid --ac-mode value: $ac_mode"
  exit 1
fi

install -d -m 0755 "$DEST_DIR"
install -m 0755 "$ROOT_DIR/scripts/power-mode-switch.sh" "$DEST_DIR/power-mode-switch.sh"
install -m 0755 "$ROOT_DIR/scripts/power-hook-dispatch.sh" "$DEST_DIR/power-hook-dispatch.sh"
install -m 0644 "$ROOT_DIR/contrib/power-hooks/99-custom-kernel-power.rules" "$UDEV_RULE_DIR/99-custom-kernel-power.rules"

cat > "$DEFAULTS_FILE" <<EOF
AC_STATE_MODE=$ac_mode
EOF

if [[ "$with_acpid" == "1" ]]; then
  install -d -m 0755 "$ACPID_EVENT_DIR"
  install -m 0644 "$ROOT_DIR/contrib/power-hooks/acpid/custom-kernel-power" "$ACPID_EVENT_DIR/custom-kernel-power"
fi

udevadm control --reload
udevadm trigger --subsystem-match=power_supply

echo "Installed custom kernel power hooks."
echo "AC mode: $ac_mode"
if [[ "$with_acpid" == "1" ]]; then
  echo "acpid event file installed at $ACPID_EVENT_DIR/custom-kernel-power"
fi
