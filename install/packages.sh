#!/bin/bash
# Packages installation

install_packages() {
    p=""
    arr=("$@")
    for package in "${arr[@]}"; do
        p+="$package "
    done
    if [[ $p != "" ]]; then
        printf "\n${BLUE}Installing $p ${NC}\n\n"
        $INSTALL $p
    fi
}

install_fzf() {
    if [[ ! -d "$HOME/.fzf" ]]; then
        printf "\n${BLUE}Installing fzf ${NC}\n\n"
        git clone https://github.com/junegunn/fzf.git $HOME/.fzf
        $HOME/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

source ~/dotfiles/install/utils.sh

# Setup gh to be in apt if not already installed
if [ $OS == "Linux" ] && ! installed gh; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list
    sudo apt update
fi

# Install necessary dependencies if not already installed
packages=(zsh curl gcc g++ git nodejs tmux ripgrep gh)
install_packages "${packages[@]}"

if [[ $OS == 'Linux' ]]; then
    linux_packages=(fd-find)
    install_packages "${linux_packages[@]}"
else
    mac_packages=(fd)
    install_packages "${mac_packages[@]}"
fi

install_fzf

# Rust
printf "\n${BLUE}Installing rust ${NC}\n\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Cargo is not exported into path right after installing, so just use fullpath
# for it

# Git delta
printf "\n${BLUE}Installing git-delta ${NC}\n\n"
$HOME/.cargo/bin/cargo install git-delta
