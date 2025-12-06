# Dotfiles

## Overview
This repository contains my personal dotfiles for configuring various tools and applications on my system. These configurations help streamline my workflow and maintain consistency across different environments.

## Included Configurations
- **Shell**: Configuration files for `bash` and `zsh`, including aliases, functions, and prompt customizations.
- **Editor**: Settings for `vim` and `neovim`, including plugins and key mappings.
- **Git**: Global `.gitconfig` file with aliases and user information.
- **Tmux**: Configuration for `tmux` to enhance terminal multiplexing.

## Quick Start

### Check Your System (macOS Users)

To determine your Mac's chip architecture:

```bash
# Check if you have Apple Silicon (M1/M2/M3) or Intel
uname -m
# Output: "arm64" = Apple Silicon, "x86_64" = Intel
```

Or use:

```bash
sysctl -n machdep.cpu.brand_string
```

### One-Click Installation
Run the installation script to automatically install all tools:

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi

# Run the installation script
chmod +x install.sh
./install.sh
```

The script will detect your OS and install all necessary tools with their dependencies.

## Manual Installation

### Prerequisites

#### Git
**macOS:**
```bash
# Git is usually pre-installed on macOS
# Or install via Homebrew
brew install git
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install git -y
```

#### Homebrew (macOS only)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon (M1/M2/M3) - Add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel - Homebrew is automatically added to PATH at /usr/local/bin
```

### Shell Tools

#### Zsh
**macOS:**
```bash
# Zsh is pre-installed on macOS (since Catalina)
# Or upgrade via Homebrew
brew install zsh
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install zsh -y
# Set zsh as default shell
chsh -s $(which zsh)
```

#### Oh My Zsh
**macOS & Ubuntu:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Editor Tools

#### Vim
**macOS:**
```bash
brew install vim
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install vim -y
```

#### Neovim
**macOS:**
```bash
brew install neovim
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install neovim -y
```

### Terminal Multiplexer

#### Tmux
**macOS:**
```bash
brew install tmux
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install tmux -y
```

### Development Tools

#### Conda (Miniconda)
**macOS (Apple Silicon - M1/M2/M3):**
```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
bash Miniconda3-latest-MacOSX-arm64.sh -b
~/miniconda3/bin/conda init zsh
```

**macOS (Intel):**
```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh -b
~/miniconda3/bin/conda init zsh
```

**Ubuntu:**
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
~/miniconda3/bin/conda init zsh
```

#### UV (Python Package Installer)
**macOS & Ubuntu:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### NVM (Node Version Manager)
**macOS & Ubuntu:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# After installation, install Node.js
nvm install --lts
nvm use --lts
```

#### Visual Studio Code
**macOS (Both Apple Silicon and Intel):**
```bash
# Homebrew automatically installs the correct version for your chip
brew install --cask visual-studio-code
# The 'code' command is automatically added to PATH
```

**Ubuntu:**
```bash
sudo snap install code --classic
```

### Git Tools

#### Lazygit
**macOS:**
```bash
brew install lazygit
```

**Ubuntu:**
```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

#### AICommit2
**macOS & Ubuntu:**
```bash
npm install -g aicommit2
```

## Applying Dotfiles

After installing the tools, apply your dotfiles using chezmoi:

```bash
# Initialize chezmoi with your dotfiles repository
chezmoi init https://github.com/yourusername/dotfiles.git

# Review changes
chezmoi diff

# Apply the dotfiles
chezmoi apply -v
```

## Post-Installation Configuration

After applying your dotfiles, you need to install plugins for various tools.

### Vim Plugin Installation

If using **vim-plug** as plugin manager:

```bash
# Install vim-plug if not already installed
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Open vim and install plugins
vim +PlugInstall +qall
```

If using **Vundle**:

```bash
# Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
vim +PluginInstall +qall
```

### Neovim Plugin Installation

If using **vim-plug**:

```bash
# Install vim-plug for Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install plugins
nvim +PlugInstall +qall
```

If using **Packer**:

```bash
# Clone Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install plugins
nvim +PackerSync +qall
```

If using **lazy.nvim**:

```bash
# lazy.nvim will auto-install on first launch
nvim
```

### Tmux Plugin Installation

If using **TPM (Tmux Plugin Manager)**:

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start a tmux session
tmux

# Install plugins (inside tmux)
# Press: prefix + I (capital i, default prefix is Ctrl+b)
```

Or install plugins via command line:

```bash
# Install plugins without entering tmux
~/.tmux/plugins/tpm/bin/install_plugins
```

Common tmux plugins to add to your `.tmux.conf`:

```bash
# Add these to your .tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
```

### Zsh Plugin Installation (Oh My Zsh)

Common plugins are built into Oh My Zsh, just enable them in `.zshrc`:

```bash
# Edit .zshrc
plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker kubectl)
```

Install additional plugins:

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Reload configuration
source ~/.zshrc
```

### Git Configuration

Verify and update your Git configuration:

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list
```

### Apply All Configurations

After installing plugins, restart your terminal or reload configurations:

```bash
# Reload zsh configuration
source ~/.zshrc

# Reload tmux configuration (inside tmux)
tmux source-file ~/.tmux.conf
```

## Updating

To update your dotfiles:

```bash
# Pull the latest changes
chezmoi update -v
```

To update plugins:

```bash
# Vim/Neovim (vim-plug)
vim +PlugUpdate +qall
nvim +PlugUpdate +qall

# Tmux plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# Oh My Zsh
omz update
```

## Troubleshooting

### Shell doesn't change after installing zsh
Log out and log back in, or run:
```bash
exec zsh
```

### Command not found after installation
Restart your terminal or run:
```bash
source ~/.zshrc
```

### Permission issues
If you encounter permission issues, you may need to run some commands with `sudo`.

## License
MIT

