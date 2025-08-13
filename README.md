# Mine Dotfiles

Mit personlige setup for en hurtig opsætning og konsistent udviklingsmiljø.

## Installation

### Forudsætninger

Installer `git`:
```bash
# Debian/Ubuntu
sudo apt update && sudo apt install git

# macOS
brew install git
```

### Installationstrin

1. Klon repository'et. Fx https:
    ```bash
    git clone https://github.com/math227v/dotfiles.git ~/dotfiles
    ```
    Eller SSH:
    ```bash
    git clone git@github.com:math227v/dotfiles.git ~/dotfiles
    ```
2. Naviger til mappen:
    ```bash
    cd ~/dotfiles
    ```
3. Kør installationsscriptet:
    ```bash
    ./scripts/install.sh
    ```

For manuel opsætning:
```bash
stow .
```

## Tilføj Nye Dotfiles

1. Flyt den eksisterende dotfile til repositoryet:
    ```bash
    mv ~/.gitconfig ~/dotfiles/
    ```
2. Naviger til dotfiles-mappen og opret symlink:
    ```bash
    cd ~/dotfiles
    stow .
    ```
3. Commit ændringer:
    ```bash
    git add .
    git commit -m "feat: add git configuration"
    git push
    ```