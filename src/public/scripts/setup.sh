#!/bin/bash

GIT_URL="https://github.com/rmenai/dotfiles"

# Warning prompt (using /dev/tty to ensure it works in non-interactive mode)
echo "WARNING: This script will perform the following actions:" > /dev/tty
echo "- Remove some files from your home directory." > /dev/tty
echo "- Change the default shell, which might slow down startup time." > /dev/tty
echo "It is strongly recommended to backup your home directory before proceeding." > /dev/tty
echo "" > /dev/tty
read -p "Do you want to proceed? (y/N): " -n 1 -r < /dev/tty
echo "" > /dev/tty # Move to a new line

# Default to 'no' if no input provided
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled." > /dev/tty
  exit 1
fi

# Make sure sudo is available
if ! command -v sudo &> /dev/tty; then
  echo "sudo could not be found. Install sudo and try again." > /dev/tty
  exit 1
fi

# Install nix
sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
curl -L https://nixos.org/nix/install | sh

. $HOME/.nix-profile/etc/profile.d/nix.sh

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell "<home-manager>" -A install

# Install yadm
nix-env -iA nixpkgs.yadm

# Import dotfiles
yadm clone $GIT_URL
yadm checkout $HOME
yadm submodule update --recursive --init

# Configure home
home-manager switch
