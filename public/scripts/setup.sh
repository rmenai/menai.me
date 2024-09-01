#!/bin/bash

curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell -p yadm --run '
  echo "Cloning your dotfiles repository with yadm..."
  cd "$HOME"
  yadm clone https://github.com/rmenai/dotfiles.git
  yadm submodule update --recursive --init

  if [ $? -ne 0 ]; then
      echo "Failed to clone the repository. Exiting..."
      exit 1
  fi

  echo "Dotfiles repository cloned successfully."
'

nix-shell "<home-manager>" -A install
home-manager switch

echo "Setup completed successfully!"
