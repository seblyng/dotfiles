#!/bin/bash

# Sets varibale to dotfiles location
OS=$(uname -s)

# This sets variables needed for installation
source ~/dotfiles/install/utils.sh

# Installs homebrew and symlinks .macos if OS is macOS. Needs to be sourced before doing $UPDATE
if [[ $OS == "Darwin" ]]; then
    source ~/dotfiles/install/mac.sh
fi

# Runs 'brew update' or 'apt-get update' based on OS
$UPDATE

# Installation
if [[ $1 == "" ]]; then
    source ~/dotfiles/install/common.sh
    source ~/dotfiles/install/packages.sh
    source ~/dotfiles/install/neovim.sh
    source ~/dotfiles/install/zsh.sh
elif [[ $1 == 'nvim' ]]; then
    source ~/dotfiles/install/neovim.sh
elif [[ $1 == 'zsh' ]]; then
    source ~/dotfiles/install/zsh.sh
fi

# Hopefully fix insecure directories if there are any
/bin/zsh -i -c compaudit | xargs chmod g-w,o-w
