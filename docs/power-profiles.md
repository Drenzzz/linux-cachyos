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

## Hook Integration

Use `scripts/power-mode-switch.sh` from an ACPI/udev hook to auto-switch based on charger state.
