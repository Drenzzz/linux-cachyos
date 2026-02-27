# Custom Kernel Goals

This repository keeps upstream layout intact and customizes only two existing variant directories.

## Scope

- Keep merge path from upstream simple.
- Build two packages:
  - `linux-custom` from `linux-cachyos-eevdf/`
  - `linux-custom-perf` from `linux-cachyos-bore/`
- Use one networking baseline for both packages: Clang + ThinLTO + TCP BBR3.

## Mode Intents

- `linux-custom` focuses on daily balance and better battery behavior.
- `linux-custom-perf` focuses on low latency and maximum responsiveness when plugged in.

## Constraints

- Do not add new variant directories.
- Keep changes concentrated near option defaults in each PKGBUILD.
- Keep build and maintenance scripts deterministic and path-agnostic.
