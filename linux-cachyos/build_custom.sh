#!/bin/bash

# build_custom.sh - Helper script for Custom CachyOS Kernel
# Automatically sets configuration for Balanced vs Performance variants

set -e

VARIANT=$1

if [[ -z "$VARIANT" ]]; then
    echo "Usage: ./build_custom.sh [balanced|performance]"
    exit 1
fi

echo "🚀 Preparing Custom Kernel Build: ${VARIANT^^}"

# Common variables (Fast Build + Native)
export _localmodcfg="yes"
export _processor_opt="native"
export _build_debug="no"
export _use_llvm_lto="thin"
export _custom_suffix="" # Reset by default

if [[ "$VARIANT" == "balanced" ]]; then
    echo "🔧 Applying BALANCED configuration..."
    export _cpusched="eevdf"
    export _HZ_ticks="600"
    export _tcp_bbr3="yes"
    export _per_gov="no"
    export _tickrate="full"
    export _cc_harder="yes"  # Enable -O3 for balanced too (it's safe)

elif [[ "$VARIANT" == "performance" ]]; then
    echo "⚡ Applying PERFORMANCE configuration..."
    export _cpusched="cachyos" # BORE scheduler
    export _HZ_ticks="1000"
    export _tcp_bbr3="yes"
    export _per_gov="yes"      # Performance governor
    export _tickrate="full"
    export _cc_harder="yes"    # Enable -O3
    export _custom_suffix="custom-perf"

else
    echo "❌ Unknown variant: $VARIANT"
    echo "Available variants: balanced, performance"
    exit 1
fi

echo "📦 Starting build process..."
echo "Configuration:"
echo "  Scheduler: $_cpusched"
echo "  Tick Rate: $_HZ_ticks Hz"
echo "  Gov: $_per_gov"
echo "  BBR3: $_tcp_bbr3"
echo "----------------------------------------"

# Run makepkg with variables exported
# We use -e to skip source extraction if already done (faster re-builds)
# But for safety first run, use regular flags.
makepkg -sirc
