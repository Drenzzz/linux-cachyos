# Custom Kernel Smoke Test Checklist

## Packaging

- `makepkg --printsrcinfo` succeeds in both variant directories.
- Package names are correct:
  - `linux-custom`
  - `linux-custom-perf`

## Boot and Runtime

- System boots with `linux-custom`.
- System boots with `linux-custom-perf`.
- Fallback kernel entry remains available.

## Performance and Power

- `linux-custom` keeps expected behavior on battery.
- `linux-custom-perf` exposes performance governor default.
- Scheduler and HZ profile match expected mode intent.

## Network

- Active congestion control is `bbr` (`sysctl net.ipv4.tcp_congestion_control`).
- Throughput and latency checks do not regress versus baseline.

## Modules

- Out-of-tree modules (if used) load without signature issues.
- Initramfs generation succeeds on install.
