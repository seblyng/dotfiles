#!/bin/bash

source ~/dotfiles/install/utils.sh

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

packages=(zsh curl gcc g++ git nodejs tmux ripgrep fzf)

if [[ $OS == 'Linux' ]]; then
    packages+=(fd-find)
else
    packages+=(fd gh)
fi

install_packages "${packages[@]}"

source <(fzf --zsh)

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

$HOME/.cargo/bin/cargo install git-delta
