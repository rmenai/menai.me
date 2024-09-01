#!/bin/bash

# Variables
TEMP_DIR=$(mktemp -d)
YADM_URL="https://github.com/TheLocehiliosan/yadm/raw/master/yadm"
YADM_BIN="$TEMP_DIR/yadm"

# Download yadm without sudo, to a temporary location
echo "Downloading yadm to temporary location..."
curl -fLo "$YADM_BIN" "$YADM_URL" && chmod a+x "$YADM_BIN"

if [ $? -ne 0 ]; then
    echo "Failed to download yadm. Exiting..."
    exit 1
fi

echo "yadm downloaded successfully."
cd "$HOME"

# Clone your dotfiles repository and initialize submodules
echo "Cloning your dotfiles repository with yadm..."
"$YADM_BIN" clone https://github.com/rmenai/dotfiles.git
"$YADM_BIN" submodule update --recursive --init

if [ $? -ne 0 ]; then
    echo "Failed to clone the repository. Exiting..."
    exit 1
fi

echo "Dotfiles repository cloned successfully."

# Clean up temporary yadm binary
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Setup completed successfully!"
