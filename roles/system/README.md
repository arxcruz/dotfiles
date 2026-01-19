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
  - `stow`
  - `tmate`
  - `virtualenvwrapper`

### Linux

- Installs a list of system packages defined by the `system_packages` variable.
- **Desktop Environment:**
  - Loads a Tilix configuration from the `files/tilix.conf` file.
  - Installs the Hack Nerd Font.

- **Server Environment:**
  - Copies a `sshd_config` file.

## Variables



### Required Variables

- `is_server`: A boolean that determines whether the target machine is a server or a desktop environment.
- `system_packages`: A list of packages to install on Linux systems. This variable must be defined in the playbook or inventory.

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
