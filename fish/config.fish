if status is-interactive
    # FZF keybindings & completion
    if type -q fzf
        fzf --fish | source
    end

    # Starship prompt
    if type -q starship
        starship init fish | source
    end
end

