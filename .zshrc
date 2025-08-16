# Append path
export PATH=$PATH:$HOME/.local/bin

# Define zinit home path
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# If zinit is not installed, install it into the ZINIT_HOME folder.
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source and load zinit
source "${ZINIT_HOME}/zinit.zsh"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/catppuccin_mocha.toml)"

# Install plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Install plugin from OhMyZsh
zinit snippet OMZP::git

# Load completions
autoload -U compinit && compinit

# Required for optimization
zinit cdreplay -q

# Configure emacs style keybinds
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Configure history
HISTSIZE=5000
HISTFILE=~/zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Configure completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}' # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Show colors
zstyle ':completion:*' menu no # Drop build-in menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # Use FZF menu instead

# Aliases
alias ls='ls --color' 
alias vim=nvim

# Init FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Export NVM to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
