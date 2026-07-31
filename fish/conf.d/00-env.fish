# Disable Fish default welcome greeting
set -g fish_greeting

# Set default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Let mise own the pnpm version. A repo's packageManager pin would otherwise make
# pnpm self-download a redundant copy into its store and re-exec into it.
set -gx pnpm_config_pm_on_fail ignore

# Mise shims path (makes mise-managed binaries available immediately)
if test -d ~/.local/share/mise/shims
    fish_add_path -g ~/.local/share/mise/shims
end

# macOS Apple Silicon Homebrew
if test -d /opt/homebrew/bin
    fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin
end

# macOS Intel / standard local bin
if test -d /usr/local/bin
    fish_add_path -g /usr/local/bin
end

# Linux / WSL Homebrew (Linuxbrew)
if test -d /home/linuxbrew/.linuxbrew/bin
    fish_add_path -g /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin
end

# User local bin
if test -d ~/.local/bin
    fish_add_path -g ~/.local/bin
end
