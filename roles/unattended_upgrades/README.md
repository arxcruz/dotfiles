# Unattended Upgrades Role

Ensures security updates actually auto-install, not just that the package is present.

## Why this role exists

`unattended-upgrades` can be installed and its systemd service "enabled" while never actually running, because the piece that triggers it - `/etc/apt/apt.conf.d/20auto-upgrades` - is a separate file that `apt-get install unattended-upgrades` does not create on its own (it's normally written by `dpkg-reconfigure unattended-upgrades`, an interactive step that's easy to skip). Without it, apt's daily timer never invokes the upgrade.

## What it does

- Installs `unattended-upgrades`.
- Writes `/etc/apt/apt.conf.d/20auto-upgrades` to actually enable the periodic timer.
- Ensures `apt-daily.timer` and `apt-daily-upgrade.timer` are enabled.

Leaves `/etc/apt/apt.conf.d/50unattended-upgrades` (which origins are allowed, e.g. Debian-Security-only) at its package default.

## Role Variables

| Variable | Default | Description |
|----------|---------|--------------|
| `unattended_upgrades_update_package_lists` | `true` | Refresh package lists daily |
| `unattended_upgrades_enable` | `true` | Actually run unattended-upgrade daily |
