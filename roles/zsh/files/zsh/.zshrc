export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# Check OS
os="$(uname -s)"

# Golang
# export GOROOT=$HOME/go
# export GOPATH=$GOROOT/bin
# export PATH=$PATH:$GOROOT/bin:$GOPATH

# The following lines were added by compinstall
# zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Tmux
# export TERM="screen-256color"

export ANTIDOTE_HOME=~/.cache/antidote

source "$HOME/.antidote/antidote.zsh"

antidote load

# Oh-my-posh
eval "$(oh-my-posh init zsh --config .oh-my-posh.omp.toml)"

# Virtualenv and fzf
if [ "${os}" '==' "Darwin" ]; then
    # Virtualenv wrapper
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Documents/Projects/
    export VIRTUALENVWRAPPER_PYTHON=/opt/homebrew/bin/python3
    source virtualenvwrapper.sh

    # fzf
    eval "$(fzf --zsh)"

else
    # Fedora doesn't have support to fzf --zsh yet
    source /usr/share/fzf/shell/key-bindings.zsh
fi

# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

source $HOME/.config/fzf-git/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
        ssh)          fzf --preview 'dig {}' "$@" ;;
        *)            fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
    esac
}

# End fzf
# Bat
export BAT_THEME="Coldark-Dark"

# Zoxide
eval "$(zoxide init zsh)"

# alias
alias cd="z"
alias vim=nvim
alias ls="eza --long --color=always --git --icons=always --no-time"
