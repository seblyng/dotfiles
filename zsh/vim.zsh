source $HOME/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_ESCAPE_KEYTIMEOUT=0.00

function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[2 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[6 q'
    fi
}

zle -N zle-keymap-select

_fix_cursor() {
    echo -ne '\e[6 q'
}
precmd_functions+=(_fix_cursor)

# Don't override fzf history widget
function zvm_after_init() {
    zvm_bindkey viins '^R' fzf-history-widget
    bindkey '^[[Z' reverse-menu-complete
}
