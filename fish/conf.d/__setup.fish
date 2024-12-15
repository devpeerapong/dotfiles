if [ (uname -m) = arm64 ]
    eval "$(/opt/homebrew/bin/brew shellenv)"
end
if [ (uname -m) = x86_64 ]
    if test -f /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
    else if test -f /home/linuxbrew/.linuxbrew/bin/brew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo 'brew bin not found'
        exit 1
    end
end

set -l brewcli fd eza bat fzf zoxide lazygit
for item in $brewcli
    if not type -q $item
        echo Installing $item
        eval "brew install $item"
        echo Done $item
    end
end

set -l brewaliascli \
    'rg repgrep' \
    'delta gitdelta' 

  
for item in $brewaliascli
    set -l line (string split " " $item)

    if not type -q $line[1]
        echo Installing $line[1]
        eval "brew install (string trim $line[2])"
        echo Done $line[1]
    end
end

set -l cli \
    'fnm' \
    'starship' \
    'fisher'

set -l clitest \
    'test -d ~/.local/share/fnm' \
    'type -q starship' \
    'test -f $__fish_config_dir/functions/fisher.fish'

set -l cliinstall \
    'curl -fsSL https://fnm.vercel.app/install | bash' \
    '/bin/bash -c "$(curl -fsSL https://starship.rs/install.sh)"' \
    'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update'

set index 1
for item in $cli
    eval $clitest[$index]

    if test ! $status -eq 0
        echo Installing $item
        eval $cliinstall[$index]
        echo Done $item
    end

    set index (math $index + 1)
end
