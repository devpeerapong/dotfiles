#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

info "Starting holistic dotfiles cleanup..."

# 1. Clean legacy files inside ~/.config/fish if it's a real directory (before symlinking)
if [ -d "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ]; then
    info "Cleaning legacy setup files from existing ~/.config/fish..."
    rm -f "$HOME/.config/fish/alias.fish" \
          "$HOME/.config/fish/set.fish" \
          "$HOME/.config/fish/fish_plugins" \
          "$HOME/.config/fish/conf.d/__setup.fish" \
          "$HOME/.config/fish/conf.d/fnm.fish" \
          "$HOME/.config/fish/functions/fisher.fish" \
          "$HOME/.config/fish/completions/fisher.fish" \
          "$HOME/.config/fish/functions/_fzf_"* \
          "$HOME/.config/fish/functions/fzf_"* \
          "$HOME/.config/fish/completions/fzf"* 2>/dev/null || true
fi

# 2. Refresh symlinks via setup.sh
if [ -f "$DOTFILES_DIR/setup.sh" ]; then
    info "Ensuring setup.sh provisions modern symlinks..."
    "$DOTFILES_DIR/setup.sh"
fi

# 3. Clean up legacy standalone / curl installations (fnm, old starship, fisher cache, fish init cache)
info "Removing legacy standalone tool installations & caches..."
rm -rf "$HOME/.local/share/fnm" \
       "$HOME/.fnm" \
       "$HOME/.config/fnm" \
       "$HOME/.cache/fisher" \
       "$HOME/.cache/fish" 2>/dev/null || true

# Remove old standalone starship binary if it exists outside mise
if [ -f "$HOME/.local/bin/starship" ] && [ ! -L "$HOME/.local/bin/starship" ]; then
    rm -f "$HOME/.local/bin/starship"
fi

# 4. Uninstall legacy Homebrew CLI formulas (now managed 100% by mise)
if command -v brew &>/dev/null; then
    info "Audit & uninstall legacy Homebrew formulas (now managed by mise)..."
    LEGACY_BREW_PACKAGES=(
        "fd"
        "eza"
        "bat"
        "fzf"
        "zoxide"
        "lazygit"
        "neovim"
        "ripgrep"
        "git-delta"
    )

    for pkg in "${LEGACY_BREW_PACKAGES[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            info "Uninstalling Homebrew formula: $pkg..."
            brew uninstall --ignore-dependencies "$pkg" 2>/dev/null || true
        fi
    done

    info "Cleaning up Homebrew orphaned dependencies & download cache..."
    brew autoremove 2>/dev/null || true
    brew cleanup -s 2>/dev/null || true
fi

# 5. Provision 100% clean mise environment
info "Provisioning modern declarative tools via mise..."
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
if command -v mise &>/dev/null; then
    mise install
    success "Mise tools provisioned successfully!"
fi

# 6. Remove old fish backup directories
if [ -d "$HOME/.config/fish.bak" ]; then
    info "Removing old fish configuration backup (~/.config/fish.bak)..."
    rm -rf "$HOME/.config/fish.bak"
fi

success "Holistic cleanup completed! Your environment is 100% modernized and clean."
