# Guarded for interactive sessions only
if status is-interactive
    # Modern replacements for legacy UNIX commands
    abbr --add ls eza
    abbr --add la "eza --all --group --header --group-directories-first --long"
    abbr --add ll "eza --long --header --git"
    abbr --add tree "eza --tree"
    abbr --add cat bat
    abbr --add top btop
end
