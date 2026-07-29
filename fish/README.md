# 🐟 Fish Shell Configuration

Modular, high-performance Fish shell setup featuring [Starship](https://starship.rs/) prompt, [Mise](https://mise.jdx.dev/) tool manager, [FZF](https://github.com/junegunn/fzf) fuzzy search, and modern CLI replacements ([eza](https://github.com/eza-community/eza), [bat](https://github.com/sharkdp/bat), [zoxide](https://github.com/ajeetdsouza/zoxide)).

---

## 📁 Directory Structure

- **`conf.d/`**: Modular startup scripts auto-loaded by Fish.
  - `00-env.fish`: Environment variables (`EDITOR`, `VISUAL`, `PATH`).
  - `abbr.fish`: Interactive shell abbreviations (`ls` → `eza`, `cat` → `bat`, etc.).
  - `fzf.fish`: FZF defaults, `fd` integration, and live preview settings.
  - `mise.fish`: Mise runtime environment activation.
  - `zoxide.fish`: Smart directory jumping (`z`, `zi`).
  - `tokyo-night-storm.fish`: Theme color palette.
- **`config.fish`**: Interactive shell init with prompt/FZF caching & local overrides (`99-local.fish`).
- **`functions/`**: Custom Fish functions.
- **`completions/`**: Custom command completions.

---

## ⚡ Command Abbreviations & Modern CLI Replacements

| Abbreviation | Expands To / Executed Command | Description |
|---|---|---|
| `ls` | `eza` | Modern `ls` replacement with colors & icons |
| `ll` | `eza --long --header --git` | Detailed list with file metadata & Git status |
| `la` | `eza --all --group --header --group-directories-first --long` | List all files including hidden |
| `tree` | `eza --tree` | Tree view of files & directories |
| `cat` | `bat` | Modern `cat` replacement with syntax highlighting |
| `top` | `btop` | Interactive resource monitor |

---

## 🔍 FZF & Zoxide Search Shortcuts

| Shortcut / Command | Action | Feature / Preview |
|---|---|---|
| <kbd>Ctrl</kbd> + <kbd>T</kbd> | Fuzzy search files | Live syntax-highlighted preview using `bat` |
| <kbd>Alt</kbd> + <kbd>C</kbd> | Fuzzy search & `cd` into directory | Live directory tree preview using `eza` |
| <kbd>Ctrl</kbd> + <kbd>R</kbd> | Fuzzy search command history | Interactive history completion |
| `z <dir>` | Jump to matching frequent directory | Powered by `zoxide` |
| `zi` | Interactive directory selection | `zoxide` + `fzf` directory picker |

---

## ⌨️ Essential Fish Keyboard Shortcuts

### Line Editing & Cursor Movement
| Keybinding | Action |
|---|---|
| <kbd>→</kbd> or <kbd>Ctrl</kbd> + <kbd>F</kbd> | Accept complete inline autosuggestion (gray text) |
| <kbd>Alt</kbd> + <kbd>→</kbd> or <kbd>Alt</kbd> + <kbd>F</kbd> | Accept single word of autosuggestion |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> / <kbd>Ctrl</kbd> + <kbd>E</kbd> | Move cursor to start / end of line |
| <kbd>Ctrl</kbd> + <kbd>U</kbd> | Clear line before cursor |
| <kbd>Ctrl</kbd> + <kbd>K</kbd> | Clear line after cursor |
| <kbd>Ctrl</kbd> + <kbd>W</kbd> | Delete previous word |
| <kbd>Alt</kbd> + <kbd>.</kbd> | Insert last argument of previous command |

### Navigation & Utilities
| Keybinding | Action |
|---|---|
| <kbd>Tab</kbd> | Trigger completion menu (use arrow keys / <kbd>Tab</kbd> to navigate) |
| <kbd>Alt</kbd> + <kbd>L</kbd> | Run `ls` (`eza`) in current directory without clearing prompt |
| <kbd>Alt</kbd> + <kbd>P</kbd> | Pipe output of last command to `less` |
| <kbd>Alt</kbd> + <kbd>H</kbd> or <kbd>F1</kbd> | Show documentation / man page for current command |
| <kbd>Ctrl</kbd> + <kbd>L</kbd> | Clear terminal screen |

---

## 🛠️ Installation & Maintenance

Symlinks are managed automatically by running `setup.sh` from the repo root:

```bash
./setup.sh
```

This symlinks this directory to `~/.config/fish`.
