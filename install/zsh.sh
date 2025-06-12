#!/bin/bash
# Installation of ZSH

source ~/dotfiles/install/utils.sh

# Install spaceship prompt
install_spaceship() {
    if [[ ! -d "$HOME/dotfiles/zsh/spaceship-prompt" ]]; then
        printf "\n${BLUE}Configuring prompt ${NC}\n\n"
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git $HOME/dotfiles/zsh/spaceship-prompt
        sudo mkdir -p /usr/local/share/zsh/site-functions
        sudo ln -sf $HOME/dotfiles/zsh/spaceship-prompt/spaceship.zsh /usr/local/share/zsh/site-functions/prompt_spaceship_setup
    fi
}

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
install_spaceship
setup_zsh
