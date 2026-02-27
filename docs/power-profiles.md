# Runtime Power Profiles

Kernel defaults help, but battery-versus-AC behavior should still be controlled in userspace.

## Recommended Mapping

- On battery: set power saver profile and energy-aware CPU policy.
- On AC: set balanced (or performance) profile.

## Manual Commands

```bash
# Battery-like profile
sudo powerprofilesctl set power-saver

# AC balanced profile
sudo powerprofilesctl set balanced

# AC max profile
sudo powerprofilesctl set performance
```

## Optional cpupower Fallback

```bash
sudo cpupower frequency-set -g powersave
sudo cpupower frequency-set -g performance
```

## Hook Integration (Auto Switch)

### Install udev hook (recommended)

```bash
sudo scripts/install-power-hooks.sh --ac-mode ac
```

Use `--ac-mode ac-perf` if you want AC state to always force performance profile.

### Optional acpid hook

```bash
sudo scripts/install-power-hooks.sh --ac-mode ac --with-acpid
```

### Installed files

- `/usr/local/libexec/custom-kernel/power-mode-switch.sh`
- `/usr/local/libexec/custom-kernel/power-hook-dispatch.sh`
- `/etc/udev/rules.d/99-custom-kernel-power.rules`
- `/etc/default/custom-kernel-power`

Optional:

- `/etc/acpi/events/custom-kernel-power`
