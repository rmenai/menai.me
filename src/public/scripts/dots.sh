#!/bin/bash
GIT_URL="https://github.com/rmenai/dotfiles"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz"
ZOXIDE_URL="https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide_0.9.6-1_amd64.deb"
TREESITTER_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v0.24.3/tree-sitter-linux-x64.gz"

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
echo "WARNING: This script will perform the following actions:" >/dev/tty
echo "- Override these dot files: $GIT_URL." >/dev/tty
echo "- Change the default shell to zsh." >/dev/tty
echo "It is strongly recommended to backup your home directory before proceeding." >/dev/tty
echo "" >/dev/tty
read -p "Do you want to proceed? (y/N): " -n 1 -r </dev/tty
echo "" >/dev/tty # Move to a new line

# Default to "no" if no input provided
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled." >/dev/tty
  exit 1
fi

# Update and add repositories
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

# Install dependencies
sudo apt install -y git yadm zsh neovim tmux ripgrep eza xsel

# Install harder dependencies
curl -L $FZF_URL | tar -xz && sudo mv fzf /usr/local/bin/
sudo chmod +x /usr/local/bin/fzf

wget -qO zoxide.deb $ZOXIDE_URL
sudo dpkg -i zoxide.deb
rm zoxide.deb

curl -L $TREESITTER_URL | gzip -d >tree-sitter
sudo chmod +x tree-sitter
sudo mv tree-sitter /usr/local/bin/

# Install WSL specific dependencies
if grep -qi microsoft /proc/version; then
  sudo apt install -y wslu
fi

# Import dotfiles
yadm clone $GIT_URL
yadm checkout $HOME
yadm submodule update --recursive --init

# Default shell
sudo chsh -s $(which zsh) $USER
zsh
