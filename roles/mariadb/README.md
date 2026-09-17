# MariaDB Role

Locks MariaDB's listening socket to a specific address (loopback by default) via a systemd socket unit drop-in.

## Why a socket drop-in instead of `bind-address`

Debian's `mariadb.socket` unit ships with `ListenStream=3306` and no address, which systemd binds as a wildcard socket on all interfaces and hands to `mariadbd` pre-opened via socket activation. This silently overrides the `bind-address` setting in `mariadb.conf.d/50-server.cnf` - `mariadbd` never gets a chance to apply its own bind address to that socket. The only reliable fix is a drop-in that overrides the socket unit's `ListenStream` directive directly.

## What it does

- Creates `/etc/systemd/system/mariadb.socket.d/override.conf` restricting the TCP listener to `mariadb_bind_address`.
- Reloads systemd and restarts `mariadb.socket` + `mariadb.service` when the override changes.

Assumes `mariadb-server` is already installed; this role only manages the socket binding.

## Role Variables

| Variable | Default | Description |
|----------|---------|--------------|
| `mariadb_bind_address` | `127.0.0.1` | Address MariaDB's TCP socket binds to |

## Caution

Applying this role restarts the live database (brief connection drop). Run it during a maintenance window.
