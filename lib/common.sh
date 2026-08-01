#!/bin/bash

# Color Helpers
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

info()    { echo -e "${BLUE}${BOLD}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}${BOLD}[SUCCESS]${RESET} $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${RESET} $1"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${RESET} $1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OS="$(uname -s)"

# Non-interactive environment setup
# NONINTERACTIVE=1 is strictly required by Homebrew's install.sh script to prevent pausing for Enter keypresses
export NONINTERACTIVE=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Safe symlink helper with target verification
link_config() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ]; then
        local current_target
        current_target="$(readlink "$dst")"
        if [ "$current_target" = "$src" ]; then
            info "Symlink already correct: $dst -> $src"
            return 0
        else
            warn "Existing symlink at $dst points to $current_target. Updating to $src..."
        fi
    elif [ -e "$dst" ]; then
        warn "Existing non-symlink found at $dst. Backing up to ${dst}.bak..."
        mv "$dst" "${dst}.bak"
    fi

    info "Linking $src -> $dst"
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
}
