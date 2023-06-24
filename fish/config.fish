if status is-interactive
    source $__fish_config_dir/alias.fish
    source $__fish_config_dir/set.fish

    starship init fish | source
end
