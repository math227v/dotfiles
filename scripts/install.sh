#!/bin/bash

echo "Installerer nødvendige pakker..."

sudo apt update
sudo apt install -y stow git curl neofetch

# Installer Starship
curl -fsSL https://starship.rs/install.sh | sh

# Gå til roden af dotfiles-repoet (en mappe op fra hvor scriptet ligger)
cd "$(dirname "$0")/.."

# Funktion til at tage backup af en eksisterende fil
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup_file="${file}.$(date +%Y%m%d%H%M%S).backup"
        echo "Backing up $file to $backup_file"
        mv "$file" "$backup_file"
    fi
}

echo "Backing up existing files"

echo "Stowing all packages..."
for pkg in $(find . -maxdepth 1 -type d -not -name ".git" -not -name ".*" -not -name "scripts" -exec basename {} \;); do
    echo "Stowing $pkg..."
    # Find alle filer i pakken, og tag backup hvis nødvendigt
    for dotfile in "$(find "$pkg" -type f)"; do
        target="$HOME/$(basename "$dotfile")"
        backup_file "$target"
    done
    stow -R "$pkg"
done

echo "All packages stowed!"
