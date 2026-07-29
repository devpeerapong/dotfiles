if type -q fzf

    # Use 'fd' for fast file searching (hidden files included, git ignored)
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # Live code syntax preview (Ctrl+T)
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=header,numbers --line-range :500 {}'"

    # Directory search & tree preview (Alt+C)
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
end
