unalias ? reload 2>/dev/null

function ? {
  printf "c='clear'"\
"\nbashrc='edit bashrc and reload'"\
"\nzshrc='edit zshrc and reload'"\
"\nreload='reload bashrc or zshrc'"\
"\npc='toggle enable proxychains'"\
"\n" | awk '{K=$0;gsub(/=.*$/,"",K);
  gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
  printf "%6s = %s\n",K,$0}' | sort -k 1,1 -b | \
  column -c $(tput cols) | less -SFX
}

alias c='clear'

alias bashrc='vim ~/.bashrc && source ~/.bashrc'
alias zshrc='vim ~/.zshrc && source ~/.zshrc'
      reload() {
        [[ -e ~/.zshrc ]] && {
          source ~/.zshrc
        } || {
          source ~/.bashrc
        }
      }

# extend

unalias grep 2>/dev/null
alias grep='grep --exclude-dir={node_modules,bower_components,dist,.bzr,.cvs,.git,.hg,.svn,.tmp} --color=always'

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
