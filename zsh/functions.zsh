# Functions

#Check if a package is installed
installed(){
    command -v "$1" >/dev/null 2>&1
}

# Compare commits
diff_commit() {
    if [ "$1" != "" ]
    then
        git diff $1~ $1
    else
        git diff HEAD~ HEAD
    fi
}

# Kill specified port
kill_port() {
    kill $(lsof -t -i:$1)
}

# Always zip recursively and change how zip command work
# Default to .zip with same name as folder/file
zip() {
    zipname=$1
    if [ $2 ] ; then
        case $2 in
            *.*)            zipname=$2 ;;
            *)              zipname=$2.zip ;;
        esac
    fi
    command zip -r $zipname $1
}

# Extract files
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1 ;;
            *.tar.gz)    tar xzf $1 ;;
            *.bz2)       bunzip2 $1 ;;
            *.rar)       rar x $1 ;;
            *.gz)        gunzip $1 ;;
            *.tar)       tar xf $1 ;;
            *.tbz2)      tar xjf $1 ;;
            *.tgz)       tar xzf $1 ;;
            *.zip)       unzip $1 ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1 ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function print_osc7() {
    if [ "$ZSH_SUBSHELL" -eq 0 ] ; then
        printf '\033]7;file://%s%s\a' "$HOST" "$PWD"
    fi
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd print_osc7
print_osc7

# Syncs pwd with a server over ssh
share() {
    if [ -z "$1" ]; then
        echo Specify a server and location, and it will sync pwd with the server
        exit 1
    fi

    rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

    fswatch -r0 -Ie $PWD/4913 --event Created --event Updated --event Removed -0 $PWD | while read -d "" event; do

        rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

    done &
}

function opencode() {
  local dir="$PWD"
  local found_config=""

  # Find the git worktree root (if any), so we only inject configs from above it
  local git_root
  git_root="$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)"

  # Walk from cwd up to HOME looking for opencode.json outside the worktree
  while [[ "$dir" != "$HOME" && "$dir" != "/" ]]; do
    # Skip dirs inside the git worktree — opencode already handles those natively
    if [[ -n "$git_root" && "$dir" == "$git_root"* ]]; then
      dir="${dir:h}"
      continue
    fi
    if [[ -f "$dir/opencode.json" ]]; then
      found_config="$dir/opencode.json"
      break
    fi
    dir="${dir:h}"
  done

  # Also check HOME itself (only if outside any worktree)
  if [[ -z "$found_config" && ( -z "$git_root" || "$HOME" != "$git_root"* ) && -f "$HOME/opencode.json" ]]; then
    found_config="$HOME/opencode.json"
  fi

  if [[ -n "$found_config" ]]; then
    OPENCODE_CONFIG="$found_config" command opencode "$@"
  else
    command opencode "$@"
  fi
}

install_neovim() {
    mkdir -p ~/Applications
    cd ~/Applications

    case "$OS" in
        Linux*) NVIM_DIR="nvim-linux64" ;;
        Darwin*) NVIM_DIR="nvim-macos" ;;
        *)
            echo "$OS not supported in function install_neovim"
            return ;;
    esac

    curl -LO https://github.com/neovim/neovim/releases/download/nightly/$NVIM_DIR.tar.gz
    tar xzf $NVIM_DIR.tar.gz
    rm $NVIM_DIR.tar.gz
    rm -rf nvim-nightly
    case "$OS" in
        Darwin*) NVIM_DIR="nvim-osx64" ;;
    esac
    mv ~/Applications/$NVIM_DIR ~/Applications/nvim-nightly

    cd -
}
