unalias d dex dexi dim dimi di dil da dl dli dlist dps dpsa dpa dupa din \
dip dclean 2>/dev/null
d() {
  [[ $# -lt 1 ]] && {
    (echo "d='docker'" && \
    echo "dc='docker-compose'" && \
    echo "dex='d export | gzip'" && \
    echo "dexi='d save | gzip'" && \
    echo "dim='cat | d import'" && \
    echo "dimi='d load -i'" && \
    echo "di='d images | less'" && \
    echo "dil='d images | first'" && \
    echo "da='d attach'" && \
    echo "dl='d logs | less'" && \
    echo "dli='d history | less'" && \
    echo "dlist='list repo tags'" && \
    echo "dh='dli'" && \
    echo "dps='d ps | less'" && \
    echo "dpsa='d ps -a | less'" && \
    echo "dpa='d pause all'" && \
    echo "dupa='d unpause all'" && \
    echo "din='d inspect | less'" && \
    echo "dip='container ip address'" && \
    echo "dclean='remove useless images'" && \
    alias | sed 's/^alias //' | \grep '^d' | \grep -E 'd ') | awk '{
    K=$0;gsub(/=.*$/,"",K); gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
    printf "%7s = %s\n",K,$0}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval 'docker $@'
}
dex() {
  [[ $# -lt 1 ]] && echo "Export container: dex <CONT> [CONT.tar.gz]" || {
    [[ -z $2 ]] && FILE="$1.tar.gz" || FILE="$2"
    d export $1 | gzip -1 - > $FILE
  }
}
dexi() {
  [[ $# -lt 1 ]] && echo "Export image: dexi <IMAGE> [IMAGE.tar.gz]" || {
    [[ -z $2 ]] && FILE="$1.tar.gz" || FILE="$2"
    d save $1 | gzip -1 - > $FILE
  }
}
dim() {
  [[ $# -lt 1 ]] && echo "Import container: dim <CONT.tar.gz> [REPO[:TAG]]" || {
    cat $1 | d import - $2
  }
}
dimi() {
  [[ $# -lt 1 ]] && echo "Import image: dimi <IMAGE.tar.gz>" || {
    d load --input="$1"
  }
}
di()   { d images $@ 2>&1 | less -FSX; }
dil()  { di -q | head -1 | tail -1; }
da()   { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d attach --sig-proxy=false $A; }
dl()   { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d logs $A 2>&1 | less -FXR; }
dli()  { [[ $# -eq 0 ]]&&A="$(dil)"||A="$@"; d history $A 2>&1 | less -FSX; }
dps()  { docker ps $@ --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.RunningFor}}\t{{.Ports}}" | less -FSX; }
dpsa() { dps -a $@; }
din()  { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d inspect $A 2>&1 | less -FSX; }
dip()  { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d inspect --format '{{.NetworkSettings.IPAddress}}' $A 2>&1 | less -FSX; }
dlist(){
  [[ $# -lt 1 ]] && echo "List repo tags on hub registry: dlist <REPO>" || {
    for arg in "$@"; do
      curl -Ls https://registry.hub.docker.com/v1/repositories/$arg/tags | \
        grep -Eo '"name":\s*"[^"]+"' | awk -F'"' '{print $4}' | column
    done
  }
}
dpa()  { for c in $(dpsaq); do dp $c; done; }
dupa() { for c in $(dpsaq); do dup $c; done; }
dclean(){
  XARGS=xargs
  if xargs --help 2>&1 | grep -q 'no-run-if-empty'; then
    XARGS="$XARGS --no-run-if-empty"
  fi
  docker images | awk '/<none>/{print $3}' | $XARGS docker rmi;
}
alias db='d build'
alias dco='d commit'
alias dcp='d cp'
alias de='d exec'
alias ded='d exec -d'
alias deit='d exec -i -t'
alias dh='dli'
alias dinfo='d -D info'
alias dk='d kill'
alias dp='d pause'
alias dpl='d pull'
alias dpo='d port'
alias dpsaq='d ps -a -q'
alias dpsl='d ps -lq'
alias dr='d run'
alias drd='d run -d'
alias drit='d run -i -t'
alias dritrm='d run -i -t --rm'
alias drm='d rm'
alias drmi='d rmi'
alias drs='d restart'
alias ds='d start'
alias dsa='d save'
alias dst='d stop'
alias dt='d tag'
alias dup='d unpause'

unalias dc f 2>/dev/null
dc() {
  [[ $# -lt 1 ]] && {
    alias | sed 's/^alias //' | \grep '^dc' | \grep 'docker-compose' | awk '{
    K=$0;gsub(/=.*$/,"",K); gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
    printf "%7s = %s\n",K,$0}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval 'docker-compose $@'
}
alias dcb='docker-compose build'
alias dck='docker-compose kill'
alias dcl='docker-compose logs'
alias dcps='docker-compose ps'
alias dcpl='docker-compose pull'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcrd='docker-compose run -d'
alias dcrrm='docker-compose run --rm'
alias dcrs='docker-compose restart'
alias dcs='docker-compose start'
alias dcsc='docker-compose scale'
alias dcst='docker-compose stop'
alias dcup='docker-compose up'
alias dcud='docker-compose up -d'
