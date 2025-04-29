#!/usr/bin/env bash

DOTFILES_REPO="https://github.com/rmenai/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# Check if the script is being run as root
if [[ $EUID -eq 0 ]]; then
  echo "ERROR: This script should not be run as root." >/dev/tty
  echo "Please create a new user in the sudoers group and run the script as that user." >/dev/tty
  exit 1
fi

# Make sure sudo is available
if ! command -v sudo &>/dev/tty; then
  echo "sudo could not be found. Install sudo and try again." >/dev/tty
  exit 1
fi

# Warning prompt (using /dev/tty to ensure it works in non-interactive mode)
echo "================================================" >/dev/tty
echo "           Dotfiles Installation Script         " >/dev/tty
echo "================================================" >/dev/tty
echo "" >/dev/tty
echo "WARNING: This script will do the following steps:" >/dev/tty
echo "" > /dev/tty
echo "  1. Install Nix (single-user, --daemon) if not already present." >/dev/tty
echo "  2. Set up Home-manager for your user." >/dev/tty
echo "  3. Clone your dotfiles repository '$DOTFILES_DIR'." >/dev/tty
echo "  4. Use GNU Stow to create symlinks to your dotfiles." >/dev/tty
echo "  6. Run 'home-manager switch' to apply your Nix configuration, install packages, etc..." >/dev/tty
echo "" >/dev/tty
echo "It is strongly recommended to backup your dotfiles before proceeding." >/dev/tty
echo "" >/dev/tty

# Default to "no" if no input provided
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled." >/dev/tty
  exit 1
fi

# Make sure Nix is available
if ! command -v nix &>/dev/null; then
  echo "Nix package manager not found." >/dev/tty
  echo "Attempting to install Nix: sh <(curl -L https://nixos.org/nix/install)" >/dev/tty
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# Installing home-manager
echo "Adding/updating home-manager channel..." >/dev/tty
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Cloning dotfiles
if [ -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles directory '$DOTFILES_DIR' already exists. Skipping clone." >/dev/tty
  echo "Make sure it contains your dotfiles and the '$HOME_NIX_RELATIVE_PATH'." >/dev/tty
  echo "Attempting to pull latest changes in $DOTFILES_DIR..." >/dev/tty
  git -C "$DOTFILES_DIR" pull
else
  echo "Cloning dotfiles repository to '$DOTFILES_DIR'..." >/dev/tty
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo "Cloning complete." >/dev/tty
fi

# Creating symlinks
echo "Running stow to create symlinks from ~/.dotfiles..." >/dev/tty
cd "$DOTFILES_DIR" || exit
nix run nixpkgs#stow -- .
cd - > /dev/null || exit

# Switch home-manager
home-manager switch
echo "" >/dev/tty
echo "Setup complete. Packages are installed and dotfiles linked." >/dev/tty
