# Upstream Merge Playbook (Custom Kernels)

This playbook keeps `linux-custom` and `linux-custom-perf` aligned with upstream updates.

## 1) Merge Upstream

```bash
git fetch upstream
git checkout <custom-branch>
git merge upstream/master
```

## 2) Re-verify Custom Defaults

- `linux-cachyos-eevdf/PKGBUILD`
  - package naming for `linux-custom`
  - ThinLTO + BBR3 + balance tuning defaults
- `linux-cachyos-bore/PKGBUILD`
  - package naming for `linux-custom-perf`
  - ThinLTO + BBR3 + perf tuning defaults

## 3) Regenerate Metadata

```bash
( cd linux-cachyos-eevdf && makepkg --printsrcinfo > .SRCINFO )
( cd linux-cachyos-bore && makepkg --printsrcinfo > .SRCINFO )
```

## 4) Build Smoke Check

```bash
scripts/build-custom-kernels.sh all
```

## 5) Pre-release Validation

- Follow `docs/custom-kernel-smoke-test.md`.
- Keep at least one known-good fallback kernel installed.
