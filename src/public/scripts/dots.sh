#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/rmenai/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# Don’t run as root
if [[ $EUID -eq 0 ]]; then
  >&2 echo "ERROR: Do not run as root; please use a normal user in sudoers."
  exit 1
fi

# Ensure prerequisites
for cmd in sudo git curl; do
  if ! command -v "$cmd" &>/dev/null; then
    >&2 echo "ERROR: Required command '$cmd' not found. Install it and re-run."
    exit 1
  fi
done

cat <<EOF
================================================
           Dotfiles Installation Script
================================================

This will:
  1. Install Nix (multi-user daemon) if missing
  2. Source Nix’s profile
  3. Configure home-manager
  4. Clone or update $DOTFILES_DIR
  5. Use GNU Stow to symlink your dotfiles
  6. Run 'home-manager switch'
  7. Source ~/.profile to load your new environment

EOF

# Prompt explicitly from the TTY
read -r -n 1 -p "Continue? [y/N] " REPLY </dev/tty
echo   # newline
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

# Install Nix if needed
if ! command -v nix &>/dev/null; then
  echo "Installing Nix (requires sudo)..."
  sh <(curl -L https://nixos.org/nix/install) --daemon

  # Make nix command available immediately
  if [[ -f /etc/profile.d/nix.sh ]]; then
    . /etc/profile.d/nix.sh
  elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
fi

# Configure home-manager
echo "Setting up home-manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Clone or update dotfiles
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "Cloning dotfiles…"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Apply Nix/home-manager configuration
echo "Applying home-manager configuration..."
home-manager switch --flake ~/.dotfiles/nixos#rami@$(hostname)

echo "Sourcing ~/.profile to finalize environment setup..."
. "$HOME/.profile"
echo "✅ Bootstrap complete!"
