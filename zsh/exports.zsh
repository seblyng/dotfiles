# Exports

export DOTFILES="$HOME/dotfiles"
export EDITOR="nvim"
export OS=$(uname -s)
export XDG_CONFIG_HOME="$HOME/.config"

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

export FZF_DEFAULT_OPTS='--height 40%'
export GOPATH=$HOME/go
export PATH="$DOTFILES/scripts:$PATH"

typeset -U path
path+=(
    /opt/local/bin
    /opt/local/sbin
    /usr/local/opt/llvm/bin
    $HOME/.cargo/bin
    $HOME/.local/bin
    $HOME/.local/flutter/bin
    $HOME/.local/share/nvim/mason/bin
    $HOME/.dotnet/tools
    $GOROOT/bin
    $GOPATH/bin
    $HOME/.local/netcoredbg
)

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export MANPAGER='nvim +Man!'

export ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump-${HOST/.*/}-${ZSH_VERSION}"
