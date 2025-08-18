#!/bin/bash

echo "Installerer nødvendige pakker..."

# Install packages
sudo apt update
sudo apt install -y git curl stow neofetch zsh unzip tmux bat eza

# Install Neovim
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# Indstil zsh som standard shell
echo "Indstiller zsh som standard shell"
chsh -s $(which zsh)

# Gå til roden af dotfiles-repoet (en mappe op fra hvor scriptet ligger)
cd "$(dirname "$0")/.."

echo "Stowing all packages..."
stow .

echo "All packages stowed!"
