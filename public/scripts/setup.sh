#!/bin/bash

GIT_URL="https://github.com/rmenai/dotfiles"

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

# Move the old config to backup
sudo cp $HOME -r "$HOME.old"

# Import dotfiles
yadm clone $GIT_URL
yadm checkout $HOME
yadm submodule update --recursive --init

# Configure home
home-manager switch
