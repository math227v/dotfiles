#!/bin/bash
# install.sh — kan køre både standalone og fra Ansible
set -euo pipefail

# -----------------------------
# Konfiguration
# -----------------------------
APT_PKGS=(git curl stow neofetch zsh unzip tmux bat eza ca-certificates openssh-client)
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NEOVIM_DEST="/usr/local/bin/nvim"

# -----------------------------
# Flag parsing: --system / --user
# -----------------------------
DO_SYSTEM=1
DO_USER=1
if [[ "${1:-}" == "--system" ]]; then DO_USER=0; fi
if [[ "${1:-}" == "--user"   ]]; then DO_SYSTEM=0; fi

# -----------------------------
# Hjælpere
# -----------------------------
have_cmd() { command -v "$1" >/dev/null 2>&1; }
is_root()  { [[ "$(id -u)" -eq 0 ]]; }
# Brug sudo hvis muligt, ellers tom (og så fejler system-ting pænt)
SUDO=""
if ! is_root; then
  if sudo -n true 2>/dev/null; then
    SUDO="sudo"
  elif have_cmd sudo; then
    # Forsøg at skaffe en sudo token (kan kræve password)
    if sudo -v; then SUDO="sudo"; fi
  fi
fi

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6 || echo "$HOME")"

ensure_dir() {
  mkdir -p "$1"
  chmod "${2:-700}" "$1"
}

log() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }

# -----------------------------
# System-del (root/sudo)
# -----------------------------
system_part() {
  if ! is_root && [[ -z "$SUDO" ]]; then
    log "Ingen sudo tilgængelig — skipper system-delen."
    return 0
  fi

  log "APT: opdaterer og installerer basispakker..."
  $SUDO apt update
  $SUDO apt install -y "${APT_PKGS[@]}"

  # Neovim AppImage til /usr/local/bin/nvim
  log "Installerer Neovim AppImage til ${NEOVIM_DEST} ..."
  tmp="$(mktemp)"
  curl -fsSL "$NEOVIM_URL" -o "$tmp"
  $SUDO install -m 0755 "$tmp" "$NEOVIM_DEST"
  rm -f "$tmp"

  # Custom MOTD
  log "Sætter custom MOTD (/etc/update-motd.d/01-custom)..."
  $SUDO tee /etc/update-motd.d/01-custom > /dev/null <<'EOF'
#!/bin/sh
export TERM=xterm; clear
echo
echo
/usr/bin/neofetch
EOF
  $SUDO chmod +x /etc/update-motd.d/01-custom

  # Standard shell -> zsh for TARGET_USER
  if have_cmd zsh; then
    if [[ "$(getent passwd "$TARGET_USER" | cut -d: -f7)" != "/bin/zsh" ]]; then
      log "Sætter standard shell til zsh for ${TARGET_USER} ..."
      if is_root; then
        usermod -s /bin/zsh "$TARGET_USER"
      else
        $SUDO usermod -s /bin/zsh "$TARGET_USER"
      fi
    fi
  fi

  # Ubuntu har ofte 'bat' som 'batcat'. Lav en venlig symlink til brugeren.
  if have_cmd batcat && ! have_cmd bat; then
    log "Opretter symlink: ~/.local/bin/bat -> batcat"
    ensure_dir "${TARGET_HOME}/.local/bin" 755
    ln -sf "$(command -v batcat)" "${TARGET_HOME}/.local/bin/bat"
    chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.local"
  fi
}

# -----------------------------
# Bruger-del (ikke-root)
# -----------------------------
user_part() {
  # Kør altid som TARGET_USER hvor det giver mening
  if is_root; then
    # Genkald script som TARGET_USER for bruger-ting (bevarer env)
    log "Skifter til bruger-kontekst for ${TARGET_USER} ..."
    exec sudo -u "$TARGET_USER" -H bash "$0" --user
  fi

  log "Installerer bruger-værktøjer (TPM, Oh My Posh, FZF, stow)..."

  # PATH til ~/.local/bin
  ensure_dir "${HOME}/.local/bin" 755
  export PATH="${HOME}/.local/bin:${PATH}"

  # TPM
  if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  fi
  "${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh" || true

  # Oh My Posh (user-space)
  curl -fsSL https://ohmyposh.dev/install.sh | bash -s

  # FZF (user-space)
  if [[ ! -d "${HOME}/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  fi
  "${HOME}/.fzf"/install --key-bindings --completion --no-update-rc --no-bash --no-fish

  # Stow dotfiles (forvent at scriptet ligger i repoet: ./scripts/install.sh)
  REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
  if [[ -f "${REPO_ROOT}/.stow-local-ignore" || -d "${REPO_ROOT}" ]]; then
    log "Stowing fra ${REPO_ROOT} ..."
    cd "${REPO_ROOT}"
    stow .
  else
    log "Kunne ikke finde repo-roden — skipper stow."
  fi

  log "Bruger-del færdig."
}

# -----------------------------
# Main
# -----------------------------
if [[ "$DO_SYSTEM" -eq 1 ]]; then system_part; fi
if [[ "$DO_USER"   -eq 1 ]]; then user_part; fi

log "Alt færdigt."

