alias c='clear'
alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias zshrc='vim ~/.zshrc && source ~/.zshrc'
alias goaccess="goaccess --log-format '%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' --date-format '%d/%b/%Y' --time-format '%H:%M:%S'"

alias npm='npm --loglevel http'
alias npmtb='npm --registry=https://registry.npm.taobao.org --disturl=https://npm.taobao.org/dist --phantomjs_cdnurl=https://npm.taobao.org/dist/phantomjs'

alias cdh='cd /home/deploy/projects/hittiger/current'
alias cds='cd /home/deploy/projects/superman/current'
alias cdn='cd /data/log/nginx'
alias rc='./bin/rails c'
alias psg='ps aux | grep'

unalias reload 2>/dev/null
      reload() {
        [[ -e ~/.zshrc ]] && {
          source ~/.zshrc
        } || {
          source ~/.bashrc
        }
      }

# network

alias nload='nload -u K'

# proxychains

unalias pc pcconf 2>/dev/null

PC="proxychains"
if hash proxychains4 2>/dev/null; then
  PC="proxychains4 -q"
fi

pc() {
  [[ $# -lt 1 ]] && {
    [[ -e ~/.proxychains/proxychains.conf ]] && {
      mv ~/.proxychains/proxychains.conf ~/.proxychains/proxychains.conf.disabled
      echo proxychains disabled
    } || {
      mv ~/.proxychains/proxychains.conf.disabled ~/.proxychains/proxychains.conf
      echo proxychains enabled
    }
  } || eval "$PC $@"
}
pcconf() {
  [[ -e ~/.proxychains/proxychains.conf.disabled ]] && {
    vim ~/.proxychains/proxychains.conf.disabled
  } || {
    vim ~/.proxychains/proxychains.conf
  }
}
