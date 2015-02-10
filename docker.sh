unalias d dex dexi dim dimi di dil da dl dli dlist dps dpsa dpa dupa din \
dip dclean f 2>/dev/null
d() {
  [[ $# -lt 1 ]] && {
    (echo "d='docker'" && \
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
    alias | sed 's/^alias //' | \grep '^[df]' | \grep -E '(d |fig)') | awk '{
    K=$0;gsub(/=.*$/,"",K); gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
    printf "%7s = %s\n",K,$0}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval 'docker $@'
}
f() {
  [[ $# -lt 1 ]] && {
    alias | sed 's/^alias //' | \grep '^f' | \grep 'fig' | awk '{
    K=$0;gsub(/=.*$/,"",K); gsub(/(^.*=\47)|(\47.*?$)/,"",$0);
    printf "%7s = %s\n",K,$0}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval 'fig $@'
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
dps()  {
  docker ps $@ | awk '
  NR==1{
    FIRSTLINEWIDTH=length($0)
    IDPOS=index($0,"CONTAINER ID");
    IMAGEPOS=index($0,"IMAGE");
    COMMANDPOS=index($0,"COMMAND");
    CREATEDPOS=index($0,"CREATED");
    STATUSPOS=index($0,"STATUS");
    PORTSPOS=index($0,"PORTS");
    NAMESPOS=index($0,"NAMES");
    UPDATECOL();
  }
  function UPDATECOL () {
    ID=substr($0,IDPOS,IMAGEPOS-IDPOS-1);
    IMAGE=substr($0,IMAGEPOS,COMMANDPOS-IMAGEPOS-1);
    COMMAND=substr($0,COMMANDPOS,CREATEDPOS-COMMANDPOS-1);
    CREATED=substr($0,CREATEDPOS,STATUSPOS-CREATEDPOS-1);
    STATUS=substr($0,STATUSPOS,PORTSPOS-STATUSPOS-1);
    PORTS=substr($0,PORTSPOS,NAMESPOS-PORTSPOS-1);
    NAMES=substr($0, NAMESPOS);
  }
  function PRINT () {
    print ID NAMES IMAGE STATUS CREATED COMMAND PORTS;
  }
  NR==2{
    NAMES=sprintf("%s%*s",NAMES,length($0)-FIRSTLINEWIDTH,"");
    PRINT();
  }
  NR>1{
    UPDATECOL();
    PRINT();
  }' | less -FSX;
}
dpsa() { dps -a $@; }
din()  {
  ([[ $# -eq 0 ]] && {
    d inspect $(dpsl) 2>&1
  } || {
    d inspect $@ 2>&1
  }) | less -FSX;
}
dip()  {
  ([[ $# -eq 0 ]] && {
    d inspect --format '{{ .NetworkSettings.IPAddress }}' $(dpsl) 2>&1
  } || {
    d inspect --format '{{ .NetworkSettings.IPAddress }}' $@ 2>&1
  }) | less -FSX;
}
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
alias dka='d kill $(d ps -aq)'
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
alias dsta='d stop $(d ps -aq)'
alias dt='d tag'
alias dup='d unpause'

alias fb='fig build'
alias fk='fig kill'
alias fl='fig logs'
alias fp='fig port'
alias fps='fig ps'
alias fpl='fig pull'
alias frm='fig rm'
alias fr='fig run'
alias frd='fig run -d'
alias frrm='fig run --rm'
alias frs='fig restart'
alias fs='fig start'
alias fsc='fig scale'
alias fst='fig stop'
alias fup='fig up'
alias fud='fig up -d'
