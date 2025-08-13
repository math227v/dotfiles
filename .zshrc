# Define zinit home path
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# If zinit is not installed, install it into the ZINIT_HOME folder.
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source and load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

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

# Init FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
