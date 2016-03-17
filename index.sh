DIR="${BASH_SOURCE[0]}"
if [[ -z "$DIR" ]]; then
  DIR="$0"
fi
DIR="$(dirname "$DIR")"
source "$DIR/docker.sh"
source "$DIR/git.sh"
source "$DIR/misc.sh"
source "$DIR/tmux.sh"
