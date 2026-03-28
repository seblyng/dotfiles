#!/bin/bash

source ~/dotfiles/install/utils.sh

setup_zsh() {
    printf "\n${BLUE}Setting up ZSH config ${NC}\n\n"
    ln -sf $HOME/dotfiles/home/.zshenv ~/
    ln -sf $HOME/dotfiles/zsh ~/.config/
    chsh -s $(which zsh)
}

install_zsh() {
    if ! installed zsh; then
        printf "\n${BLUE}Installing zsh ${NC}\n\n"
        $INSTALL zsh
    fi
}

install_plugins() {
    if [[ ! -d "$HOME/dotfiles/zsh/plugins/zsh-vi-mode" ]]; then
        printf "\n${BLUE}Setting up vim-mode plugin for zsh${NC}\n\n"
        git clone https://github.com/jeffreytse/zsh-vi-mode $HOME/dotfiles/zsh/plugins/zsh-vi-mode
    fi
}

install_zsh
install_plugins
curl -sS https://starship.rs/install.sh | sh
setup_zsh
