#!/bin/bash

# Variables
TEMP_DIR=$(mktemp -d)
YADM_URL="https://github.com/TheLocehiliosan/yadm/raw/master/yadm"
YADM_BIN="$TEMP_DIR/yadm"

# Dependencies
if ! command -v apt &> /dev/null
then
  echo "apt package manager could not be found. This script only supports apt-based systems."
  exit 1
fi

if command -v sudo &> /dev/null
then
  SUDO="sudo"
else
  SUDO=""
  echo "sudo could not be found. Running commands without sudo."
fi

${SUDO} apt update
${SUDO} apt install -y git unzip zsh yadm neovim tmux

echo "Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/bin

# Download yadm without sudo, to a temporary location
echo "Downloading yadm to temporary location..."
curl -fLo "$YADM_BIN" "$YADM_URL" && chmod a+x "$YADM_BIN"

if [ $? -ne 0 ]; then
  echo "Failed to download yadm. Exiting..."
  exit 1
fi

echo "yadm downloaded successfully."
cd "$HOME"

echo "Configuring Git..."
git config --global init.defaultBranch main
git config --global user.name "Rami Menai"
git config --global user.email "rami@menai.me"

echo "Checking for .profile and .zshrc files..."
if [ -f "$HOME/.profile" ]; then
    echo "Removing .profile..."
    rm "$HOME/.profile"
fi

if [ -f "$HOME/.zshrc" ]; then
    echo "Removing .zshrc..."
    rm "$HOME/.zshrc"
fi

# Clone your dotfiles repository and initialize submodules
echo "Cloning your dotfiles repository with yadm..."
"$YADM_BIN" clone https://github.com/rmenai/dotfiles.git
"$YADM_BIN" submodule update --recursive --init

if [ $? -ne 0 ]; then
    echo "Failed to clone the repository. Exiting..."
    exit 1
fi

echo "Dotfiles repository cloned successfully."

if ! chsh -s $(which zsh); then
  echo "Failed to set zsh as the default shell. You may need to run chsh manually."
else
  echo "zsh has been set as the default shell."
fi

# Clean up temporary yadm binary
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Setup completed successfully!"
