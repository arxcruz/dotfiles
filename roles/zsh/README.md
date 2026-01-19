# Zsh Role

This Ansible role installs and configures Zsh with a modern shell setup including antidote plugin manager, oh-my-posh prompt, fzf fuzzy finder, and various productivity tools.

## Description

The role performs the following tasks:
- Installs Zsh and related packages across different operating systems (Linux, macOS)
- Downloads and configures antidote plugin manager
- Deploys OS-specific .zshrc configuration from Jinja2 template
- Deploys additional Zsh configuration files (.zshenv, .zsh_plugins.txt, .oh-my-posh.omp.toml)
- Sets Zsh as the default shell (Linux only)

The generated .zshrc includes:
- PATH configuration
- Zsh completion system
- Antidote plugin manager integration
- Oh-my-posh prompt theme
- Virtualenvwrapper setup
- FZF (fuzzy finder) with custom keybindings and previews
- Zoxide (smart cd alternative)
- Bat (cat alternative with syntax highlighting)
- Custom aliases for modern CLI tools (eza, nvim)

## Role Variables

All variables are defined in `defaults/main.yml` and can be overridden in your playbook or inventory.

**Note**: Sensitive variables (Claude configuration) are stored in `vars/vault.yml` and should be encrypted with `ansible-vault`. See the [main README](../../README.md) for vault usage instructions.

### Available Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `zsh_workon_home` | `$HOME/.virtualenvs` | Directory for Python virtual environments (virtualenvwrapper) |
| `zsh_project_home` | `$HOME/Documents/Projects/` | Default directory for projects (virtualenvwrapper) |
| `zsh_bat_theme` | `Coldark-Dark` | Color theme for bat (syntax highlighting tool) |
| `zsh_claude_use_vertex` | `{{ vault_zsh_claude_use_vertex }}` | Enable Claude Code Vertex AI integration (from vault) |
| `zsh_cloud_ml_region` | `{{ vault_zsh_cloud_ml_region }}` | Cloud ML region for Claude Code (from vault) |
| `zsh_anthropic_vertex_project_id` | `{{ vault_zsh_anthropic_vertex_project_id }}` | Anthropic Vertex project ID (from vault) |

## Example Playbook

### Basic Usage

```yaml
---
- hosts: all
  roles:
    - zsh
```

### Custom Configuration

```yaml
---
- hosts: all
  roles:
    - role: zsh
      vars:
        zsh_workon_home: "$HOME/.venvs"
        zsh_project_home: "$HOME/dev/projects/"
        zsh_bat_theme: "Nord"
```

### Per-Host Configuration

```yaml
---
- hosts: workstation
  roles:
    - role: zsh
      vars:
        zsh_project_home: "$HOME/work/projects/"
        zsh_claude_use_vertex: 0

- hosts: laptop
  roles:
    - role: zsh
      vars:
        zsh_project_home: "$HOME/personal/projects/"
        zsh_bat_theme: "Monokai Extended"
```

## License

MIT
