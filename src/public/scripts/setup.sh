#!/bin/bash

GIT_URL="https://github.com/rmenai/dotfiles"

# Warning prompt
echo "WARNING: This script will perform the following actions:"
echo "- Remove some files from your home directory."
echo "- Change the default shell, which might slow down startup time."
echo "It is strongly recommended to backup your home directory before proceeding."
echo ""
read -p "Do you want to proceed? (Y/n): " -n 1 -r
echo # Move to a new line

# Default to 'no' if no input provided
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 1
fi

# Make sure sudo is available
if ! command -v sudo &> /dev/null; then
  echo "sudo could not be found. Install sudo and try again."
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
