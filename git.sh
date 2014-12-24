# git aliases
CARE() {
  cbtpl=">CB<"
  cbval="$(git rev-parse --abbrev-ref HEAD)"
  commd="${@//$cbtpl/$cbval}"
  cbtpl=">OCB<"
  cbval="origin/$cbval"
  commd="${commd//$cbtpl/$cbval}"
  echo -e "\033[1;49;34m$commd\033[0m"
  sleep 1
  eval "$commd"
}
export GLFMT="%C(bold blue)%h%C(reset) (%ar) %s"
unalias g gar gb gbc gblc gbr gch gclb gds gfh gg gl gla glc gld gmm gsf 2>/dev/null
g() {
  [[ $# -lt 1 ]] && {
    (echo "g='git'" && \
    echo "gar='archive current branch'" && \
    echo "gb='git branch'" && \
    echo "gbc='show current branch'" && \
    echo "gblc='count contribs by author'" && \
    echo "gbr='show recent git branches'" && \
    echo "gch='git cherry -v'" && \
    echo "gclb='clone single branch'" && \
    echo "gds='show diff size changes'" && \
    echo "gfh='git fetch and reset hard'" && \
    echo "gg='git grep'" && \
    echo "gl='git log'" && \
    echo "gla='git log (files created)'" && \
    echo "glc='gla'" && \
    echo "gld='git log (files deleted)'" && \
    echo "gmm='checkout master, merge'" && \
    echo "gsf='diff stash [number]'" && \
    alias | sed 's/^alias //' | grep git) | awk '{
    sub(/\x27$/,"",$0);s=index($0,"="); printf "%5s = %s\n",
    substr($0,0,s-1), substr($0,s+2)}' | sort -k 1,1 -b | \
    column -c $(tput cols) | less -SFX
  } || eval "git $@"
}
alias ga='git add'
alias gaa='git add -A .'
alias gam='git am'
alias gap='git add -p'
      gar() { CARE "git archive >CB< -o >CB<-latest.tar.gz"; }
      gb()  { git branch $@ | column -c $(tput cols) | less -XSFR; }
      gbc() { git rev-parse --abbrev-ref HEAD; }
alias gbl='git blame'
      gblc() {
        [[ $# -ne 1 ]] && echo "gblc <file>" || {
          git blame --line-porcelain "$1" | \
          sed -n 's/^author //p' | \
          sort | uniq -c | sort -rn;
        }
      }
      gbr() {
        git for-each-ref --sort=-committerdate \
        --format "%(committerdate:relative)%09%(refname:short)" \
        --count 10 refs/heads/
      }
alias gc='git checkout'
      gch() { git cherry -v $@ | less -XSF; }
alias gcl='git clone'
      gclb() {
        [[ $# -ne 2 ]] && echo "gclb <branch> <URL>" || {
           git clone --single-branch -b "$1" "$2";
        }
      }
alias gc-='git checkout -'
alias gcm='git checkout master'
alias gco='git commit'
alias gcoa='git commit --amend'
alias gcp='git cherry-pick'
alias gd='LESS=-FXR git diff'
alias gdc='LESS=-FXR git diff --cached'
      gds() {
        git diff --raw --abbrev=40 $@ | awk '{
        orig="git cat-file -s "$3" 2>/dev/null"; orig | getline origsize;
        curr="git cat-file -s "$4" 2>/dev/null"; curr | getline currsize;
        if (length(origsize) == 0) origsize = 0;
        if (length(currsize) == 0) currsize = 0;
        if (origsize == 0) {
          percent="N/A";
        } else {
          per=(currsize-origsize)/origsize*100
          if (per<-100||per>100) {
            percent=sprintf("%.0f%%", per)
          } else {
            percent=sprintf("%.2f%%", per)
          }
        }
        printf "%-9d%-9d%-11s%s\n", origsize, currsize, percent, $6;
        close(orig); close(curr);
        }' | sort -nrk 3 | less -XSF
      }
alias gf='git fetch --all'
      gfh() { CARE "git fetch origin && git reset --hard >OCB<"; }
alias gfp='git format-patch'
      gg() { git grep --break --heading -n -i -E $@; }
alias gi='git init'
      gl()  { LESS=-FXRS git log --format="$GLFMT" $@; }
      gla() { git log --diff-filter=A --format="%n$GLFMT" --summary $@; }
      glc() { gla; }
      gld() { git log --diff-filter=D --format="%n$GLFMT" --summary $@; }
alias gm='git merge'
      gmm() { CARE "git checkout master && git merge >CB<"; }
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grv='git remote -v'
alias grm='git rebase master'
alias grl='LESS=-FXRS git reflog'
alias gps='CARE "git push origin >CB<"'
alias gpl='CARE "git pull origin >CB<"'
alias gs='LESS=-XFR git -p status -uall'
alias gsa='git stash apply'
alias gsc='CARE "git stash clear"'
alias gsd='git stash drop'
      gsf() {
        [[ $# -lt 1 ]] && git diff -R stash@{0} || {
          git diff -R stash@{$1} ${@:2};
        };
      }
alias gsh='LESS=-FXSR git show'
alias gsl='LESS=-FXS git stash list'
alias gsp='git stash pop'
alias gss='git stash save'
alias gsv='git stash show -p'
alias gt='git tag'
alias gz='git reset'
alias gzh='CARE "git reset --hard"'
alias gzp='git reset -p'
