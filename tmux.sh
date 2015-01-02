unalias t 2>/dev/null
t() {
  [[ $# -lt 1 ]] && {
    (echo "t='tmux'" && \
    alias | sed 's/^alias //' | \grep ^t | \grep 'tmux') | awk '{
    K=$0;gsub(/=.*$/,"",K); gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
    printf "%7s = %s\n",K,$0}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval 'tmux $@'
}
alias ta='tmux attach'
alias tconf='vim ~/.tmux.conf'
alias td='tmux detach'
alias tn='tmux new'
alias tls='tmux ls'
