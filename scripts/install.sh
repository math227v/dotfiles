#!/bin/bash

echo "Installerer nødvendige pakker..."

sudo apt update
sudo apt install -y git curl stow neofetch zsh unzip

# Install Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Indstil zsh som standard shell
echo "Indstiller zsh som standard shell"
chsh -s $(which zsh)

# Gå til roden af dotfiles-repoet (en mappe op fra hvor scriptet ligger)
cd "$(dirname "$0")/.."

echo "Stowing all packages..."
stow .

echo "All packages stowed!"
