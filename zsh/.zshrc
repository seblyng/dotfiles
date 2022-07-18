# ZSH

source $HOME/.config/zsh/exports.zsh

# Remove % at end of print when not using \n
PROMPT_EOL_MARK=""

plugins=(git zsh-z tmux zsh-vi-mode)

source $ZSH/oh-my-zsh.sh
source $HOME/.config/zsh/spaceship.zsh

[ -f ~/.local.zsh ] && source ~/.local.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/vim.zsh

installed pyenv && eval "$(pyenv init -)"

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

[ -f ~/.linuxbrew/bin/brew ] && eval $(~/.linuxbrew/bin/brew shellenv)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
