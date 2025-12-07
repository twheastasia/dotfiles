#!/bin/bash

# Dotfiles Installation Script
# This script automatically installs all required tools for the dotfiles configuration
# Supports: macOS and Ubuntu

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        # Detect Mac chip architecture
        if [[ $(uname -m) == "arm64" ]]; then
            MAC_ARCH="arm64"
            log_info "Detected macOS (Apple Silicon - M1/M2/M3)"
        else
            MAC_ARCH="x86_64"
            log_info "Detected macOS (Intel)"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]]; then
                OS="ubuntu"
                log_info "Detected Ubuntu"
            else
                log_error "Unsupported Linux distribution. This script supports Ubuntu only."
                exit 1
            fi
        else
            log_error "Cannot detect Linux distribution"
            exit 1
        fi
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew (macOS only)
install_homebrew() {
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Configure PATH based on chip architecture
            if [[ "$MAC_ARCH" == "arm64" ]]; then
                log_info "Configuring Homebrew PATH for Apple Silicon..."
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
                eval "$(/opt/homebrew/bin/brew shellenv)"
                export PATH="/opt/homebrew/bin:$PATH"
            else
                log_info "Homebrew installed at /usr/local (Intel)"
                # Intel Macs use /usr/local/bin which is already in PATH
            fi
            
            log_success "Homebrew installed"
        else
            log_success "Homebrew already installed"
            # Ensure Homebrew is in PATH for current session
            if [[ "$MAC_ARCH" == "arm64" ]] && [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
                export PATH="/opt/homebrew/bin:$PATH"
            fi
        fi
    fi
}

# Update package manager
update_package_manager() {
    if [[ "$OS" == "ubuntu" ]]; then
        log_info "Updating apt..."
        sudo apt update
        log_success "apt updated"
    elif [[ "$OS" == "macos" ]]; then
        log_info "Updating Homebrew..."
        brew update
        log_success "Homebrew updated"
    fi
}

# Install Git
install_git() {
    if ! command_exists git; then
        log_info "Installing Git..."
        if [[ "$OS" == "macos" ]]; then
            brew install git
        elif [[ "$OS" == "ubuntu" ]]; then
            sudo apt install git -y
        fi
        log_success "Git installed"
    else
        log_success "Git already installed ($(git --version))"
    fi
}

# Install Zsh
install_zsh() {
    if ! command_exists zsh; then
        log_info "Installing Zsh..."
        if [[ "$OS" == "macos" ]]; then
            brew install zsh
        elif [[ "$OS" == "ubuntu" ]]; then
            sudo apt install zsh -y
        fi
        log_success "Zsh installed"
    else
        log_success "Zsh already installed ($(zsh --version))"
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        log_success "Oh My Zsh installed"
    else
        log_success "Oh My Zsh already installed"
    fi
}

# Set Zsh as default shell
set_zsh_default() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting Zsh as default shell..."
        if command_exists zsh; then
            chsh -s "$(which zsh)"
            log_success "Zsh set as default shell (restart terminal to apply)"
        fi
    else
        log_success "Zsh is already the default shell"
    fi
}

# Install Vim
install_vim() {
    if ! command_exists vim; then
        log_info "Installing Vim..."
        if [[ "$OS" == "macos" ]]; then
            brew install vim
        elif [[ "$OS" == "ubuntu" ]]; then
            sudo apt install vim -y
        fi
        log_success "Vim installed"
    else
        log_success "Vim already installed ($(vim --version | head -n 1))"
    fi
}

# Install Neovim
install_neovim() {
    if ! command_exists nvim; then
        log_info "Installing Neovim..."
        if [[ "$OS" == "macos" ]]; then
            brew install neovim
        elif [[ "$OS" == "ubuntu" ]]; then
            sudo apt install neovim -y
        fi
        log_success "Neovim installed"
    else
        log_success "Neovim already installed ($(nvim --version | head -n 1))"
    fi
}

# Install Tmux
install_tmux() {
    if ! command_exists tmux; then
        log_info "Installing Tmux..."
        if [[ "$OS" == "macos" ]]; then
            brew install tmux
        elif [[ "$OS" == "ubuntu" ]]; then
            sudo apt install tmux -y
        fi
        log_success "Tmux installed"
    else
        log_success "Tmux already installed ($(tmux -V))"
    fi
}

# Install Conda
install_conda() {
    if ! command_exists conda; then
        log_info "Installing Miniconda..."
        if [[ "$OS" == "macos" ]]; then
            if [[ "$MAC_ARCH" == "arm64" ]]; then
                log_info "Downloading Miniconda for Apple Silicon..."
                curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
                bash Miniconda3-latest-MacOSX-arm64.sh -b -p "$HOME/miniconda3"
                rm Miniconda3-latest-MacOSX-arm64.sh
            else
                log_info "Downloading Miniconda for Intel..."
                curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
                bash Miniconda3-latest-MacOSX-x86_64.sh -b -p "$HOME/miniconda3"
                rm Miniconda3-latest-MacOSX-x86_64.sh
            fi
        elif [[ "$OS" == "ubuntu" ]]; then
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
            bash Miniconda3-latest-Linux-x86_64.sh -b -p "$HOME/miniconda3"
            rm Miniconda3-latest-Linux-x86_64.sh
        fi
        "$HOME/miniconda3/bin/conda" init zsh
        log_success "Miniconda installed"
    else
        log_success "Conda already installed ($(conda --version))"
    fi
}

# Install UV
install_uv() {
    if ! command_exists uv; then
        log_info "Installing UV..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        log_success "UV installed"
    else
        log_success "UV already installed ($(uv --version))"
    fi
}

# Install NVM
install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        log_success "NVM installed"
        
        # Install Node.js LTS
        if command_exists nvm; then
            log_info "Installing Node.js LTS..."
            nvm install --lts
            nvm use --lts
            log_success "Node.js LTS installed"
        fi
    else
        log_success "NVM already installed"
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
}

# Install Visual Studio Code
install_vscode() {
    # Check if VS Code is installed
    local vscode_installed=false
    if [[ "$OS" == "macos" ]]; then
        if [ -d "/Applications/Visual Studio Code.app" ]; then
            vscode_installed=true
        fi
    elif [[ "$OS" == "ubuntu" ]]; then
        if command_exists code; then
            vscode_installed=true
        fi
    fi
    
    if $vscode_installed; then
        log_success "Visual Studio Code already installed"
        return
    fi
    
    log_info "Installing Visual Studio Code..."
    if [[ "$OS" == "macos" ]]; then
        brew install --cask visual-studio-code
    elif [[ "$OS" == "ubuntu" ]]; then
        if command_exists snap; then
            sudo snap install code --classic
        else
            log_warning "snap not available, skipping VS Code installation"
            log_info "Please install VS Code manually from https://code.visualstudio.com/"
            return
        fi
    fi
    log_success "Visual Studio Code installed"
}

# Install Lazygit
install_lazygit() {
    if ! command_exists lazygit; then
        log_info "Installing Lazygit..."
        if [[ "$OS" == "macos" ]]; then
            brew install lazygit
        elif [[ "$OS" == "ubuntu" ]]; then
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit lazygit.tar.gz
        fi
        log_success "Lazygit installed"
    else
        log_success "Lazygit already installed ($(lazygit --version))"
    fi
}

# Install AICommit2
install_aicommit2() {
    if ! command_exists aicommit2; then
        log_info "Installing AICommit2..."
        # Ensure Node.js is available
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        if command_exists npm; then
            npm install -g aicommit2
            log_success "AICommit2 installed"
        else
            log_error "npm not found. Please install Node.js first."
        fi
    else
        log_success "AICommit2 already installed"
    fi
}

# Install Chezmoi
install_chezmoi() {
    if ! command_exists chezmoi; then
        log_info "Installing Chezmoi..."
        if [[ "$OS" == "macos" ]]; then
            brew install chezmoi
        elif [[ "$OS" == "ubuntu" ]]; then
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            fi
        fi
        log_success "Chezmoi installed"
    else
        log_success "Chezmoi already installed ($(chezmoi --version))"
    fi
}

# Main installation function
main() {
    echo -e "${GREEN}"
    echo "=================================================="
    echo "  Dotfiles Installation Script"
    echo "=================================================="
    echo -e "${NC}"
    
    # Detect operating system
    detect_os
    
    echo ""
    if [[ "$OS" == "macos" ]]; then
        log_info "System Architecture: $MAC_ARCH"
    fi
    log_info "Starting installation process..."
    echo ""
    
    # Install in dependency order
    install_homebrew          # macOS only
    update_package_manager
    install_git              # Required by many tools
    install_zsh              # Shell
    install_oh_my_zsh        # Zsh framework
    install_vim              # Editor
    install_neovim           # Editor
    install_tmux             # Terminal multiplexer
    install_conda            # Python environment manager
    install_uv               # Python package installer
    install_nvm              # Node version manager (also installs Node.js)
    install_vscode           # Code editor
    install_lazygit          # Git UI
    install_aicommit2        # AI commit message generator (requires Node.js)
    install_chezmoi          # Dotfiles manager
    set_zsh_default          # Set Zsh as default shell
    
    echo ""
    echo -e "${GREEN}"
    echo "=================================================="
    echo "  Installation Complete!"
    echo "=================================================="
    echo -e "${NC}"
    echo ""
    log_info "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Apply dotfiles: chezmoi apply -v"
    echo "  3. Configure aicommit2 with your API key if needed"
    echo ""
    log_warning "Some changes may require logging out and back in to take effect."
}

# Run main function
main
