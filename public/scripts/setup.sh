#!/bin/bash

# Variables
YADM_URL="https://github.com/TheLocehiliosan/yadm/raw/master/yadm"
GIT_URL="https://github.com/rmenai/dotfiles"

# Dependencies
if ! command -v apt &> /dev/null; then
  echo "apt package manager could not be found. This script only supports apt-based systems."
  exit 1
fi

if ! command -v sudo &> /dev/null; then
  echo "sudo could not be found. Installing sudo."
  apt update
  apt install -y sudo
fi

sudo apt update
sudo apt install -y git unzip

# Download yadm without sudo, to a temporary location
echo "Installing yadm..."
sudo curl -fLo /usr/bin/yadm "$YADM_URL" && sudo chmod a+x /usr/bin/yadm

if [ $? -ne 0 ]; then
  echo "Failed to download yadm. Exiting..."
  exit 1
fi

echo "yadm downloaded successfully."
cd "$HOME"

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
yadm clone --bootstrap ${GIT_URL}
yadm submodule update --recursive --init

if [ $? -ne 0 ]; then
  echo "Failed to clone the repository. Exiting..."
  exit 1
fi

echo "Dotfiles repository cloned successfully."

echo "Running bootstrap"
chmod a+x .config/yadm/bootstrap
yadm bootstrap
