# devpeerapong/dotfiles

Dotfiles for Fish Shell + mise on macOS and WSL.

## Setup

```bash
git clone https://github.com/devpeerapong/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./setup.sh
```

## Structure

- `setup.sh` — Bootstrap installer (Homebrew, Ghostty, Fish, mise, symlinks)
- `cleanup.sh` — Remove legacy configs and re-provision
- `git/config` — Git config with delta diffs (includes `~/.config/git/config.local`)
- `mise/config.toml` — Declarative tool versions (node, pnpm, eza, bat, fzf, etc.)
- `fd/ignore` — Global fd search exclusions
- `ghostty/config` — Ghostty terminal config (font, etc.)
- `starship.toml` — Prompt theme
- `fish/` — Fish shell config
  - `conf.d/00-env.fish` — PATH setup
  - `conf.d/abbr.fish` — Abbreviations (ls→eza, cat→bat, top→btop)
  - `conf.d/fzf.fish` — fzf + fd + bat/eza previews
  - `conf.d/mise.fish` — mise activation
  - `conf.d/zoxide.fish` — zoxide cd hook
  - `conf.d/tokyo-night-storm.fish` — Theme colors

## Machine-Local Overrides

- **Git identity**: `~/.config/git/config.local`
- **Fish overrides**: `~/.config/fish/conf.d/99-local.fish`
