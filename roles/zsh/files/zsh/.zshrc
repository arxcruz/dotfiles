# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to jhbuild
export PATH=$PATH:$HOME/.local/bin

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Neovim
alias vim=nvim

# Tmux
export TERM="screen-256color"

os="$(uname -s)"
case "${os}" in
    Linux*) home_dir="/home/arxcruz/"
            ;;
    Darwin*) home_dir="/Users/arxcruz/"
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
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# antigen theme bhilburn/powerlevel9k powerlevel9k
antigen theme romkatv/powerlevel10k
antigen theme https://github.com/iam4x/zsh-iterm-touchbar

# Load theme font

# POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_MODE='awesome'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

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
plugins=(git)

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
    source /usr/local/bin/virtualenvwrapper.sh

    # Autojump
    source /usr/local/etc/profile.d/autojump.sh

else
    source /usr/share/autojump/autojump.zsh
fi

alias authkey='oathtool --hotp $(cat ~/.oath/key) -c $([ ! -f ~/.oath/counter ] && echo -n 0 > ~/.oath/counter || echo -n $(($(cat ~/.oath/counter)+1)) > ~/.oath/counter; cat ~/.oath/counter)'
alias pinauth='[ ! -r ~/.oath/pin ] && echo "No PIN stored." || echo "$(cat ~/.oath/pin)$(authkey)"'
