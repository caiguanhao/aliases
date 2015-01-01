unalias t 2>/dev/null
t() {
  [[ $# -lt 1 ]] && {
    (echo "t='tmux'" && \
    alias | sed 's/^alias //' | grep ^t | grep 'tmux') | awk '{
    sub(/\x27$/,"",$0);s=index($0,"="); printf "%7s = %s\n",
    substr($0,0,s-1), substr($0,s+2)}' | sort -k 1,1 -b | column
  } || eval 'tmux $@'
}
alias ta='tmux attach'
alias tconf='vim ~/.tmux.conf'
alias td='tmux detach'
alias tn='tmux new'
alias tls='tmux ls'
