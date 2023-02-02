# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to jhbuild
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# Golang
# export GOROOT=$HOME/go
# export GOPATH=$GOROOT/bin
# export PATH=$PATH:$GOROOT/bin:$GOPATH

# Neovim
alias vim=nvim

# Tmux
# export TERM="screen-256color"

os="$(uname -s)"
case "${os}" in
    Linux*) home_dir="/home/$USER/"
            ;;
    Darwin*) home_dir="/Users/$USER/"
             export LANG=en_US.UTF-8 LC_CTYPE="en_US.UTF-8"
             # Use python from brew
             export PATH="/usr/local/opt/python/libexec/bin:$PATH"
             ;;
esac

# Path to your oh-my-zsh installation.
export ZSH="${home_dir}".oh-my-zsh

# Antigen
source "${home_dir}".zsh/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme romkatv/powerlevel10k
#
# Tell Antigen that you're done.
antigen apply

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
if [ "${os}" '==' "Darwin" ]; then
    # Virtualenv wrapper
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Documents/Projects/
    export VIRTUALENVWRAPPER_PYTHON=/opt/homebrew/bin/python3
    source virtualenvwrapper.sh

    # Autojump
    [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

else
    source /usr/share/autojump/autojump.zsh
fi

# Load powerlevel10k
source ~/.p10k.zsh

# Aliases
my_code() {
    unset selected
    if [[ $# -eq 1 ]]; then
        selected=$1
    fi
    items=`find ~/projetos -maxdepth 2 -mindepth 1 -type d`
    items+="\n"
    items+=`find ~/repos -maxdepth 3 -mindepth 1 -type d`
    test -z "$selected" && selected=`echo "$items" | fzf`

    dirname=`basename $selected`

    tmux switch-client -t $dirname
    if [[ $? -eq 0 ]]; then
        exit 0
    fi

    tmux new-session -c $selected -d -s $dirname && tmux switch-client -t $dirname || tmux new -c $selected -A -s $dirname
}

neovim_config() {
    tmux switch-client -t 'neovim-config'
    if [[ $? -eq 0 ]]; then
        exit 0
    fi
    tmux new -s neovim-config -d
    tmux send-keys -t neovim-config 'cd ~/.config/nvim' C-m
    tmux send-keys -t neovim-config 'vim init.lua' C-m
    tmux attach -t neovim-config
}

alias mc=my_code
alias nv=neovim_config
