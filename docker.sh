unalias d dex dexi dim dimi dcd di dil da dl dli dlist dps dpsa dpa dupa din \
dwipe denter dexpose dclose 2>/dev/null
d() {
  [[ $# -lt 1 ]] && {
    (echo "d='docker'" && \
    echo "dex='d export | gzip'" && \
    echo "dexi='d save | gzip'" && \
    echo "dim='cat | d import'" && \
    echo "dimi='d load -i'" && \
    echo "dcd='cd to container root'" && \
    echo "di='d images | less'" && \
    echo "dil='d images | first'" && \
    echo "da='d attach'" && \
    echo "dl='d logs | less'" && \
    echo "dli='d history | less'" && \
    echo "dlist='list repo tags'" && \
    echo "dpid='get state pid'" && \
    echo "dh='dli'" && \
    echo "dps='d ps | less'" && \
    echo "dpsa='d ps -a | less'" && \
    echo "dpa='d pause all'" && \
    echo "dupa='d unpause all'" && \
    echo "din='d inspect | less'" && \
    echo "drms='drm stopped'" && \
    echo "dwipe='dka; drma; drmia'" && \
    echo "denter='enter a container'" && \
    echo "dexpose='expose a port'" && \
    echo "dclose='close a port'" && \
    alias | sed 's/^alias //' | grep ^d | grep 'd ') | awk '{
    sub(/\x27$/,"",$0);s=index($0,"="); printf "%7s = %s\n",
    substr($0,0,s-1), substr($0,s+2)}' | sort -k 1,1 -b | column
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
dcd()  {
  [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@";
  ID="$(din -f '{{.Id}}' $A)"
  DIRS="$(sudo find /var/lib/docker/ -maxdepth 3 -type d -name "$ID")"
  for DIR in $DIRS; do
    sudo ls -l "$DIR/root" >/dev/null 2>&1 && echo "$DIR" && cd "$DIR" 2>/dev/null
  done
}
di()   { d images $@ 2>&1 | less -FSX; }
dil()  { di -q | head -1 | tail -1; }
da()   { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d attach --sig-proxy=false $A; }
dl()   { [[ $# -eq 0 ]]&&A="$(dpsl)"||A="$@"; d logs $A 2>&1 | less -FXR; }
dli()  { [[ $# -eq 0 ]]&&A="$(dil)"||A="$@"; d history $A 2>&1 | less -FSX; }
dps()  { d ps $@ 2>&1 | less -FSX; }
dpsa() {
  d ps -a | awk 'NR==1{
    A=index($0,"IMAGE");
    B=substr($0,0,A-1);
    C=index($0,"NAMES");
    D=substr($0,A,C-A-1);
    E=length($0);
    F=substr($0,C)
  }
  NR==2{
    print B F sprintf("%*s",length($0)-E,"") D
  }
  NR>1{
    print substr($0,0,A-1)substr($0,C)substr($0,A,C-A-1)
  }' | less -FSX;
}
din()  { d inspect $@ 2>&1 | less -FSX; }
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
dwipe(){
  dupa 2>/dev/null; dka 2>/dev/null; drma 2>/dev/null; drmia 2>/dev/null;
}
denter(){ sudo nsenter --target $(dpid $@) --mount --uts --ipc --net --pid; }
dexpose(){
  [[ $# -lt 2 ]] && echo "dexpose <CONTAINER> <PORT>" || {
    IP=$(din --format "{{.NetworkSettings.IPAddress}}" $1)
    sudo iptables -t nat -A DOCKER -p tcp --dport $2 -j DNAT --to-destination $IP:$2
  }
}
dclose(){
  [[ $# -lt 2 ]] && echo "dclose <CONTAINER> <PORT>" || {
    IP=$(din --format "{{.NetworkSettings.IPAddress}}" $1)
    sudo iptables -t nat -D DOCKER -p tcp --dport $2 -j DNAT --to-destination $IP:$2
  }
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
alias dpid='din --format "{{.State.Pid}}"'
alias dpl='d pull'
alias dpo='d port'
alias dpsaq='d ps -a -q'
alias dpsl='d ps -lq'
alias dr='d run'
alias drd='d run -d'
alias drit='d run -i -t'
alias dritrm='d run -i -t --rm'
alias drm='d rm'
alias drms='drm $(comm -3 <(dps -q | sort) <(dpsaq | sort))'
alias drma='d rm $(d ps -aq)'
alias drmi='d rmi'
alias drmia='d rmi $(d images -q)'
alias drs='d restart'
alias ds='d start'
alias dsa='d save'
alias dst='d stop'
alias dsta='d stop $(d ps -aq)'
alias dt='d tag'
alias dup='d unpause'
