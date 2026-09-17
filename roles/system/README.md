# System Role

This role configures a development environment on macOS and Linux systems.

## Tasks

The role performs the following tasks:

### General (all systems)

- Clones the `fzf-git.sh` repository to `~/.config/fzf-git`.
- Installs a `.gitconfig` file in the user's home directory.

### macOS

- Installs [Homebrew](https://brew.sh/) if it's not already installed.
- Installs the `svn` package.
- Installs several fonts using `homebrew_cask`:
  - `font-droid-sans-mono-for-powerline`
  - `font-droid-sans-mono-nerd-font`
  - `font-hack-nerd-font`
- Installs the following packages using Homebrew:
  - `bat`
  - `coreutils`
  - `eza`
  - `fd`
  - `fzf`
  - `git-delta`
  - `git-review`
  - `npm`
  - `python`
  - `tmate`
  - `virtualenvwrapper`

### Linux

- Installs a list of system packages defined by the `system_packages` variable.
- **Desktop Environment:**
  - Loads a Tilix configuration from the `files/tilix.conf` file.
  - Installs the Hack Nerd Font.

- **Server Environment:**
  - Purges legacy/unnecessary packages (`system_server_purge_packages`, e.g. Python 2, Apache2, znc) and autoremoves orphaned dependencies.
  - Deploys an SSH hardening drop-in to `/etc/ssh/sshd_config.d/99-hardening.conf` (`PermitRootLogin no`, `PasswordAuthentication no`, etc.), validated with `sshd -t` before being applied, and reloads sshd on change.

## Variables



### Required Variables

- `is_server`: A boolean that determines whether the target machine is a server or a desktop environment.
- `system_packages`: A list of packages to install on Linux systems. This variable must be defined in the playbook or inventory.

### Optional Variables (server only)

- `system_server_purge_packages` (default in `defaults/main.yml`): list of packages to purge on server hosts.

### Example

Here is an example of how to use this role in a playbook:

```yaml
- hosts: all
  roles:
    - role: system
      vars:
        is_server: false
        system_packages:
          - build-essential
          - curl
          - git
          - vim
```
