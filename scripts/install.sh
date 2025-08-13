#!/bin/bash

echo "Installerer nødvendige pakker..."

sudo apt update
sudo apt install -y stow git starship curl

# Gå til roden af dotfiles-repoet (en mappe op fra hvor scriptet ligger)
cd "$(dirname "$0")/.."

# Find alle mapper i den nuværende mappe (undtagen .git og scripts)
# og kør 'stow' på hver af dem.
#
# -maxdepth 1: Kig kun i den nuværende mappe, ikke i undermapper.
# -type d: Find kun mapper.
# -not -name ".git": Ignorer .git-mappen.
# -not -name "scripts": Ignorer vores script-mappe.
# -exec ...: Kør en kommando for hvert fund.
#
# basename {} fjerner stien og giver kun mappenavnet.

echo "Stowing all packages..."
for pkg in $(find . -maxdepth 1 -type d -not -name ".git" -not -name ".*" -not -name "scripts" -exec basename {} \;); do
    echo "Stowing $pkg..."
    stow -R "$pkg"
done

echo "All packages stowed!"
