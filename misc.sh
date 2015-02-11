alias c='clear'
alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias zshrc='vim ~/.zshrc && source ~/.zshrc'

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

# ssh

unalias sendx listenx 2>/dev/null
alias sshx='ssh -R 29431:localhost:29431'
      sendx() {
        [[ $# -lt 2 ]] && {
          Files="pasteboard"
          [[ $# -eq 1 ]] && {
            if cat $1 | file - | grep -iq text; then
              cp $1 /tmp
              cp $1 /tmp/pasteboard
              Files="$(basename "$1") pasteboard"
            else
              tar -cvf - $1 | gzip | nc -q0 localhost 29431
              return
            fi
          } || {
            cat > /tmp/pasteboard
          }
          tar -C /tmp -cvf - $Files | gzip | nc -q0 localhost 29431
          (cd /tmp && rm -f $Files)
        } || {
          tar -cvf - $@ | gzip | nc -q0 localhost 29431
        }
      }
      listenx() {
        mkdir -p tmp
        echo "use sendx command on remote system to send files to ./tmp"
        while :; do
          nc -l 29431 | tar -C tmp -xvz -f -
          if [[ -f tmp/pasteboard ]]; then
            if file tmp/pasteboard | grep -iq text; then
              cat tmp/pasteboard | pbcopy
            fi
            rm -f tmp/pasteboard
          fi
          sleep 0.5
        done
      }
