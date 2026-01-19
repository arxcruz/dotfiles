# Ansible Role: tmux

This role installs and configures tmux.

## Role Description

This role performs the following actions:

1.  **Installs tmux:** It installs the `tmux` package on the target machine. The installation method is adapted for different operating systems (Linux and macOS).
2.  **Deploys Configuration:** It deploys a `.tmux.conf` file to the user's home directory (`{{ ansible_user_dir }}`). The configuration is generated from a template (`tmux.conf.j2`) and includes OS-specific settings.

## Configuration

The configuration is managed through the `tmux.conf.j2` template and includes the following features:

### General Settings

*   `escape-time`: Set to `5` for faster escape sequence processing.
*   `focus-events`: Enabled for better terminal focus handling.
*   `renumber-windows`: Enabled to automatically renumber windows when one is closed.
*   **Mouse Support:** Mouse mode is enabled by default. It can be toggled on and off with `<prefix> m` and `<prefix> M` respectively.

### OS-Specific Settings

The template uses Ansible facts to apply OS-specific configurations for `copy-command` and `powerline`.

*   **`copy-command`**:
    *   On **macOS**, it uses `pbcopy`.
    *   On **Linux** (Arch, Fedora, Debian), it uses `xsel -i`.
*   **`powerline`**:
    *   The `powerline.conf` path is set based on the operating system:
        *   **macOS**: `/opt/homebrew/lib/python3.10/site-packages/powerline/bindings/tmux/powerline.conf`
        *   **Arch Linux**: `/usr/lib/python3.10/site-packages/powerline/bindings/tmux/powerline.conf`
        *   **Fedora**: `/usr/lib/python3.10/site-packages/powerline/bindings/tmux/powerline.conf`
        *   **Other**: `/usr/share/tmux/powerline.conf`

### Key Bindings

*   **Pane Navigation:** Seamless navigation between tmux panes and Vim splits using `Ctrl` + `h`, `j`, `k`, `l`.
*   **Copy Mode:**
    *   `C-j`, `Enter`, and `MouseDragEnd1Pane` in copy mode will copy the selection to the clipboard.

## Variables

This role uses the following variables:

*   `ansible_system`: Used to determine the operating system (Linux or Darwin).
*   `ansible_distribution`: Used to determine the Linux distribution (e.g., Archlinux, Fedora).
*   `ansible_os_family`: Used to determine the OS family (e.g., Debian, RedHat).
*   `ansible_user_dir`: The home directory of the user. This is used as the destination for the `.tmux.conf` file.

## Dependencies

This role requires the following:

*   `tmux` to be available in the system's package manager.
*   `powerline` to be installed and configured on the system.
*   `xsel` to be installed on Linux systems for clipboard integration.

## Example Playbook

Here's an example of how to use this role in a playbook:

```yaml
- hosts: all
  roles:
    - tmux
```
