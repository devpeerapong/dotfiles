if [ (uname -m) = arm64 ]
    eval "$(/opt/homebrew/bin/brew shellenv)"
end
if [ (uname -m) = x86_64 ]
    eval "$(/usr/local/bin/brew shellenv)"
end

set -l list \
    'fd			brew install fd' \
    'rg			brew install ripgrep' \
    'bat		brew install bat' \
    'fzf		brew install fzf' \
    'zoxide		brew install zoxide' \
    'lazygit	brew install lazygit' \
    'fnm		/bin/bash -c "$(curl -fsSL https://fnm.vercel.app/install)"' \
    'starship	/bin/bash -c "$(curl -fsSL https://starship.rs/install.sh)"' \
    'fisher		curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update'

for item in $list
    set -l line (string split -m 1 \t $item)

    if not type -q $line[1]
        echo Installing $line[1]
        eval (string trim $line[2])
        echo Done $line[1]
    end
end
