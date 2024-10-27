#!/bin/bash
GIT_URL="https://github.com/rmenai/dotfiles"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz"
FZF_TMUX_URL="https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux"
ZOXIDE_URL="https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide_0.9.6-1_amd64.deb"
TREESITTER_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v0.24.3/tree-sitter-linux-x64.gz"
YAZI_URL="https://github.com/sxyazi/yazi/releases/download/v0.3.3/yazi-x86_64-unknown-linux-gnu.zip"
SESH_URL="https://github.com/joshmedeski/sesh/releases/download/v2.6.0/sesh_Linux_x86_64.tar.gz"

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
echo " Override these dot files: $GIT_URL." >/dev/tty
echo " Install a lot of packages" >/dev/tty
echo "It is strongly recommended to backup your home directory before proceeding." >/dev/tty
echo "" >/dev/tty
read -p "Do you want to proceed? (y/N): " -n 1 -r </dev/tty
echo "" >/dev/tty # Move to a new line

# Default to "no" if no input provided
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled." >/dev/tty
  exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit

# Update and add repositories
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

# Install dependencies
sudo apt install -y git yadm zsh neovim tmux ripgrep xsel bat btop

if apt-cache search ^exa$ | grep -q "^exa"; then
  sudo apt install -y exa
elif apt-cache search ^eza$ | grep -q "^eza"; then
  sudo apt install -y eza
else
  echo "Neither exa nor eza package is available on this system."
  exit 1
fi

# Install harder dependencies
sudo curl -L $FZF_URL | sudo tar -xz && sudo mv fzf /usr/local/bin/
sudo chmod +x /usr/local/bin/fzf

sudo curl -L $FZF_TMUX_URL -o /usr/local/bin/fzf-tmux
sudo chmod +x /usr/local/bin/fzf-tmux

sudo wget -qO zoxide.deb $ZOXIDE_URL
sudo dpkg -i zoxide.deb
sudo rm zoxide.deb

sudo curl -L $TREESITTER_URL | sudo gzip -d >tree-sitter
sudo chmod +x tree-sitter
sudo mv tree-sitter /usr/local/bin/

# Install yazi
sudo wget -qO yazi.zip $YAZI_URL
sudo unzip -d yazi yazi.zip
sudo mv yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
sudo chmod +x /usr/local/bin/yazi
sudo rm -rf yazi yazi.zip

# Install Sesh
sudo wget -qO sesh.tar.gz $SESH_URL
sudo tar -xvzf sesh.tar.gz
sudo mv sesh /usr/local/bin/
sudo chmod +x /usr/local/bin/sesh
sudo rm sesh.tar.gz

sudo ln -s /usr/bin/batcat /usr/local/bin/bat

# Install WSL specific dependencies
if grep -qi microsoft /proc/version; then
  sudo apt install -y wslu
fi

# Clean up temporary directory
cd $HOME
rm -rf "$TEMP_DIR"

# Import dotfiles
yadm clone $GIT_URL
yadm checkout $HOME
yadm submodule update --recursive --init

bat cache --build

echo "Please run the following command to make Zsh your default shell:"
echo "  chsh -s \$(which zsh)"
echo "Note: You may need to log out and back in for the change to take effect."
zsh
