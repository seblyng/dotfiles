OS=$(uname -s)
INSTALL=""
UPDATE=""

case "$OS" in
    Linux*)
        INSTALL="sudo apt-get install -y"
        UPDATE="sudo apt-get update"
        ;;
    Darwin*)
        INSTALL="brew install"
        UPDATE="brew update"
        ;;
esac

installed() {
    command -v "$1" >/dev/null 2>&1
}

BLUE='\033[0;1;34m'
NC='\033[0m'
