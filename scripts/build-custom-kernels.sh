#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-all}"
SYNCDEPS="${SYNCDEPS:-1}"

usage() {
  cat <<'EOF'
Usage: scripts/build-custom-kernels.sh [balance|perf|all]

Environment:
  SYNCDEPS=1   Run makepkg with --syncdeps (default)
  SYNCDEPS=0   Run makepkg without --syncdeps
EOF
}

case "$MODE" in
  balance) targets=("linux-cachyos-eevdf") ;;
  perf) targets=("linux-cachyos-bore") ;;
  all) targets=("linux-cachyos-eevdf" "linux-cachyos-bore") ;;
  -h|--help) usage; exit 0 ;;
  *) usage; exit 1 ;;
esac

common_flags=(--noconfirm)
if [[ "$SYNCDEPS" == "1" ]]; then
  common_flags+=(--syncdeps)
fi

for dir in "${targets[@]}"; do
  echo "[build] $dir"
  makepkg -Ccf "${common_flags[@]}" --dir "$ROOT_DIR/$dir"
done

echo "[done] build completed for mode: $MODE"
