# Bind9 Role

Manages `named.conf.options` only - not zone files or ACLs, which are site-specific and left untouched. By default this disables recursion, which is what you want on a server that's only supposed to be authoritative for its own zones; leaving recursion on with no restriction turns the box into an open resolver that can be abused for DNS amplification attacks against third parties.

The rendered file is validated with `named-checkconf` before it's put in place - if it's invalid, the task fails instead of leaving `named` running on a broken config.

## Role Variables

| Variable | Default | Description |
|----------|---------|--------------|
| `bind9_directory` | `/var/cache/bind` | BIND's working directory |
| `bind9_recursion` | `false` | Whether to answer recursive queries for any client |
| `bind9_allow_query` | `any` | Who can query this server (zone transfers are governed separately by each zone's `allow-transfer`, untouched by this role) |

## Example

```yaml
- hosts: dns_servers
  roles:
    - role: bind9
```
