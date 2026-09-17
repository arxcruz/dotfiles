# Iptables Role

Server firewall via `iptables-persistent`/`netfilter-persistent`. Default-deny inbound on both IPv4 and IPv6, with an explicit allow-list for TCP/UDP ports plus ICMP.

This is a separate role from the desktop-oriented `firewall` role (which manages `ufw` for gaming ports). Servers on this Debian setup don't have `ufw` installed and are managed with `iptables-persistent` directly, matching the distro's native nftables-backed iptables tooling.

## What it does

- Installs `iptables-persistent` (preseeded to skip the interactive "save current rules?" prompt).
- Renders `/etc/iptables/rules.v4` and `/etc/iptables/rules.v6` from templates.
- Applies the rules via `netfilter-persistent reload` when they change.
- Ensures `netfilter-persistent` is enabled so rules survive a reboot.

Existing Docker NAT chains (if any) are preserved untouched; only the `INPUT`/`FORWARD` filter policy and allow-list are managed.

## Role Variables

| Variable | Default | Description |
|----------|---------|--------------|
| `iptables_allowed_tcp_ports` | `[22, 80, 443, 53]` | TCP ports accepted from anywhere |
| `iptables_allowed_udp_ports` | `[53]` | UDP ports accepted from anywhere |
| `iptables_allow_ping` | `true` | Allow ICMP echo-request (IPv4). ICMPv6 is always allowed since IPv6 neighbor discovery depends on it |

## Example

```yaml
- hosts: servers
  roles:
    - role: iptables
      vars:
        iptables_allowed_tcp_ports: [22, 80, 443]
        iptables_allowed_udp_ports: []
```

## Caution

Applying this role over SSH can lock you out if `22` isn't in `iptables_allowed_tcp_ports`, or if you're connecting on a non-default SSH port. Test with `--check` first, and keep a secondary access path (provider console) available the first time you run it against a new host.
