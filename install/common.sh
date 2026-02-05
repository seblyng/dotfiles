#!/bin/bash

source ~/dotfiles/install/utils.sh

symlink_files_in_dir() {
    shopt -s dotglob
    for FILE in $HOME/dotfiles/$1/*; do
        printf "\n${BLUE}Setting up ${FILE##*/} ${NC}\n\n"
        ln -sf $FILE $HOME
    done
}

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin

ln -sf $HOME/dotfiles/scripts/replace_icons.sh $HOME/.local/bin/icons
ln -sf $HOME/dotfiles/scripts/capture $HOME/.local/bin/capture

ln -sf $HOME/dotfiles/kitty $HOME/.config
ln -sf $HOME/dotfiles/helix $HOME/.config
ln -sf $HOME/dotfiles/ghostty $HOME/.config
ln -sf $HOME/dotfiles/bat $HOME/.config
ln -sf $HOME/dotfiles/delta $HOME/.config
ln -sf $HOME/dotfiles/keycast $HOME/.config

symlink_files_in_dir home
symlink_files_in_dir git
