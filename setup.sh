#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

info "Starting dotfiles setup on OS: $OS"

# 1. System Dependencies & Homebrew Setup
if [ "$OS" = "Darwin" ]; then
    info "macOS detected. Checking Xcode Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode Command Line Tools..."
        xcode-select --install || true
    fi

    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Initialize Homebrew env for script execution
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    info "Applying macOS developer preferences..."
    if [ "$(defaults read com.apple.dock autohide-delay 2>/dev/null)" != "0" ]; then
        defaults write com.apple.dock autohide-delay -float 0 2>/dev/null || true
    fi
    if [ "$(defaults read NSGlobalDomain KeyRepeat 2>/dev/null)" != "2" ]; then
        defaults write NSGlobalDomain KeyRepeat -int 2 2>/dev/null || true
    fi
    if [ "$(defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null)" != "15" ]; then
        defaults write NSGlobalDomain InitialKeyRepeat -int 15 2>/dev/null || true
    fi
    if [ "$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null)" != "1" ]; then
        defaults write com.apple.finder AppleShowAllFiles -bool true 2>/dev/null || true
    fi
    if [ "$(defaults read com.apple.finder ShowPathbar 2>/dev/null)" != "1" ]; then
        defaults write com.apple.finder ShowPathbar -bool true 2>/dev/null || true
    fi

    info "Installing macOS Homebrew casks (FiraCode Nerd Font, Ghostty)..."
    brew install --cask font-fira-code-nerd-font ghostty 2>/dev/null || true

elif [ "$OS" = "Linux" ]; then
    info "Linux/WSL detected."
    if ! command -v brew &>/dev/null && [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        info "Installing Linuxbrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
    fi

    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# 2. Core Dependencies (Fish & Mise)
info "Installing core shell & package manager (fish, mise)..."
if command -v brew &>/dev/null; then
    # btop is installed here (not via mise) since it ships no macOS release binaries
    brew install fish mise btop
else
    warn "Homebrew not active; ensuring mise is available via curl fallback..."
    if ! command -v mise &>/dev/null; then
        curl https://mise.run | sh
    fi
fi

# 3. Create ~/.config directory and link configurations
mkdir -p "$HOME/.config"

link_config "$DOTFILES_DIR/fish" "$HOME/.config/fish"
link_config "$DOTFILES_DIR/mise" "$HOME/.config/mise"
link_config "$DOTFILES_DIR/fd" "$HOME/.config/fd"
link_config "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
link_config "$DOTFILES_DIR/herdr" "$HOME/.config/herdr"
link_config "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
link_config "$DOTFILES_DIR/git/config" "$HOME/.config/git/config"

# 4. Provision All CLI Tools & Runtimes via Mise
info "Provisioning CLI tools & runtimes declared in mise/config.toml..."
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
if command -v mise &>/dev/null; then
    mise install -y
    success "Mise tools provisioned successfully!"
else
    warn "Mise binary not found in PATH yet. Run 'mise install' manually after shell restart."
fi

# 5. Set Default Shell to Fish
FISH_BIN="$(command -v fish || echo "")"
if [ -n "$FISH_BIN" ]; then
    if ! grep -q "$FISH_BIN" /etc/shells 2>/dev/null; then
        info "Adding $FISH_BIN to /etc/shells (requires sudo)..."
        echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null || warn "Could not add $FISH_BIN to /etc/shells"
    fi

    if [ "${SHELL:-}" != "$FISH_BIN" ]; then
        info "Changing default shell to $FISH_BIN..."
        chsh -s "$FISH_BIN" || warn "Could not automatically change default shell. Run: chsh -s $FISH_BIN"
    fi
fi

success "Dotfiles setup completed cleanly! Restart your terminal to enjoy your new environment."
