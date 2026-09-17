# Fail2ban Role

Installs fail2ban and layers a hardening override on top of the Debian package's own jail defaults (which already enable `sshd`, `nginx-http-auth`, and `named-refused-{tcp,udp}` on this setup via `jail.local`/`jail.d/defaults-debian.conf` - this role doesn't touch which jails are enabled, only the ban duration and the `recidive` escalation jail).

## What it does

- Installs `fail2ban`.
- Deploys `/etc/fail2ban/jail.d/99-hardening.local`:
  - Raises the default `bantime` for all jails (stock Debian default is 10 minutes, too short for a box that eats constant credential-stuffing traffic).
  - Enables the `recidive` jail, which escalates: any IP banned 3 times in a day (fail2ban's stock `recidive` settings) gets banned for a week instead of getting the same short ban forever.
- Reloads fail2ban when the config changes.

## Role Variables

| Variable | Default | Description |
|----------|---------|--------------|
| `fail2ban_bantime` | `3600` | Base ban duration in seconds for all jails |
| `fail2ban_enable_recidive` | `true` | Enable escalating bans for repeat offenders |

## Example

```yaml
- hosts: servers
  roles:
    - role: fail2ban
      vars:
        fail2ban_bantime: 86400
```
