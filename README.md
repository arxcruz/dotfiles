# Dotfiles

This repository contains my personal dotfiles and development environment configuration, managed with Ansible for easy deployment across multiple systems and operating systems.

## Overview

This repository uses Ansible roles to deploy and manage dotfiles. This approach provides several benefits:

- **OS-specific configurations**: Automatically generates appropriate configs for different operating systems (Linux, macOS)
- **Template-based**: Uses Jinja2 templates to create clean configuration files without runtime conditionals
- **Idempotent**: Can be run multiple times safely
- **Modular**: Each tool has its own role for easy management
- **Secure**: Sensitive variables can be encrypted with Ansible Vault

## Available Roles

| Role | Description |
|------|-------------|
| `system` | System-level configuration and packages |
| `neovim` | Neovim text editor configuration |
| `powerline` | Powerline status bar configuration |
| `tmux` | Terminal multiplexer configuration |
| `weechat` | IRC client configuration |
| `zsh` | Zsh shell with modern tools (fzf, zoxide, antidote, oh-my-posh) |
| `g13` | Logitech G13 configuration |

## Prerequisites

- Ansible installed on your system
- Git (for cloning the repository)
- Supported OS: Linux (Fedora, Arch Linux, Debian-based) or macOS

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Playbook

```bash
# Run all roles
ansible-playbook run.yml --ask-become-pass

# Run specific roles with tags
ansible-playbook run.yml --tags zsh,tmux --ask-become-pass

# Run on localhost
ansible-playbook run.yml -i "localhost," --connection=local --ask-become-pass
```

### Available Playbooks

- `run.yml` - Main playbook that runs all roles
- `desktop.yml` - Desktop-specific configuration
- `razer.yml` - Razer-specific configuration

## Using Ansible Vault for Sensitive Data

Some roles contain sensitive information (API keys, credentials, project IDs) that should not be stored in plain text. This repository uses Ansible Vault to encrypt sensitive variables.

### Encrypting a Vault File

```bash
# Encrypt a vault file (first time)
ansible-vault encrypt roles/<role-name>/vars/vault.yml

# You'll be prompted to create a vault password
```

### Editing Encrypted Vault Files

```bash
# Edit encrypted vault file
ansible-vault edit roles/<role-name>/vars/vault.yml

# You'll be prompted for the vault password
```

### Running Playbooks with Vault

When you have encrypted vault files, you need to provide the vault password:

```bash
# Prompt for vault password
ansible-playbook run.yml --ask-vault-pass --ask-become-pass

# Use a password file
ansible-playbook run.yml --vault-password-file ~/.vault_pass --ask-become-pass

# Use environment variable
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
ansible-playbook run.yml --ask-become-pass
```

### Creating a Vault Password File

```bash
# Create password file
echo "your-secure-password" > ~/.vault_pass
chmod 600 ~/.vault_pass

# Add to .gitignore
echo ".vault_pass" >> ~/.gitignore
```

## Configuration

### OS-Specific Variables

The repository includes OS-specific variable files in the `vars/` directory:
- `vars/debian.yml` - Debian-based distributions
- `vars/fedora.yml` - Fedora
- `vars/archlinux.yml` - Arch Linux
- `vars/default.yml` - Default fallback

These are automatically loaded based on your system's distribution.

### Customizing Roles

Each role can be customized by:
1. Overriding variables in the playbook
2. Editing role defaults in `roles/<role-name>/defaults/main.yml`
3. Creating host-specific or group-specific variables in inventory

Example:
```yaml
---
- hosts: all
  roles:
    - role: zsh
      vars:
        zsh_bat_theme: "Nord"
        zsh_project_home: "$HOME/dev/projects/"
```

## Role Documentation

Each role has its own README with detailed documentation:
- [zsh](roles/zsh/README.md)

## Tips

### Running Specific Roles

Use tags to run only specific roles:
```bash
ansible-playbook run.yml --tags zsh
ansible-playbook run.yml --tags "zsh,tmux,neovim"
```

### Dry Run

Test what would change without making actual changes:
```bash
ansible-playbook run.yml --check --diff
```

### Verbose Output

For debugging:
```bash
ansible-playbook run.yml -v    # Verbose
ansible-playbook run.yml -vv   # More verbose
ansible-playbook run.yml -vvv  # Very verbose
```

## License

MIT
