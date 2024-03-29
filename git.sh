# git aliases
CARE() {
  PC=
  [[ -e ~/.proxychains/proxychains.conf ]] && {
    PC=proxychains
    hash proxychains4 2>/dev/null && PC="proxychains4 -q"
  }
  CMD="$@"
  if [[ $CMD == *\>CB\<* || $CMD == *\>OCB\<* ]]; then
    branch="$(git rev-parse --abbrev-ref HEAD)"
    STATUS=$?
    [[ $STATUS -ne 0 ]] && return
    CMD="${CMD//>CB</$branch}"
    CMD="${CMD//>OCB</origin/$branch}"
  fi
  CMD="${CMD//>PC</$PC}"
  CMD="$(echo $CMD | sed -e 's/^ *//' -e 's/ *$//')"
  echo -e "\033[1;49;34m$CMD\033[0m"
  sleep 1
  eval "$CMD"
}
export GLFMT="%C(bold blue)%h%C(reset) (%ar) %s"
unalias gar gb gbc gblc gbr gcb gch gcl gclb gds gf gfh gg gh gl gla glc gld gmm gps gpl gsf 2>/dev/null
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
      gcl() { CARE ">PC< git clone $@"; }
      gclb() {
        [[ $# -ne 2 ]] && echo "gclb <branch> <URL>" || {
          CARE ">PC< git clone --single-branch -b $1 $2";
        }
      }
alias gc-='git checkout -'
      gbrr(){
        git for-each-ref --sort=-committerdate \
        --format "%(refname:short)" refs/heads/;
      }
      gcb() {
        local BRANCH;
        gbrr | awk '{print NR") "$0}';
        while [[ -z "$BRANCH" ]]; do
          printf "Enter branch number to checkout to: ";
          read ANSWER;
          BRANCH="$(gbrr | head -n $ANSWER 2>/dev/null | tail -1)";
        done;
        git checkout $BRANCH;
      }
alias gcm='git checkout master'
alias gcs='git checkout staging'
alias gco='git commit'
alias gcoa='git commit --amend'
alias gcp='git cherry-pick'
alias gd='LESS=-FXSR git diff'
alias gdc='LESS=-FXSR git diff --cached'
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
      gf()  { CARE ">PC< git fetch --all"; }
      gfh() { CARE ">PC< git fetch origin && git reset --hard >OCB<"; }
alias gfp='git format-patch'
      gg() { git grep --break --heading -n -i -E $@; }
      gh() {
        URL=$(git remote -v 2>/dev/null | awk '/fetch/{
          gsub(/^.*@|\.git$/,"",$2);
          gsub(/:/,"/",$2);
          "git rev-parse --abbrev-ref HEAD 2>/dev/null"|getline branch;
          "pwd"|getline pwd;
          "git rev-parse --show-toplevel 2>/dev/null"|getline root;
          path=substr(pwd,length(root)+1);
          print"https://"$2"/tree/"branch path;
          exit
        }');
        [[ -z $URL ]] && {
          echo "No GitHub link to open.";
          return 1;
        } || { echo Opening "$URL"; sleep 1; open "$URL"; }
      }
alias gi='git init'
      gl()  { LESS=-FXRS git -c log.showsignature=false log --format="$GLFMT" $@; }
      gla() { git log --diff-filter=A --format="%n$GLFMT" --summary $@; }
      glc() { gla; }
      gld() { git log --diff-filter=D --format="%n$GLFMT" --summary $@; }
alias gm='git merge'
      gmm() { CARE "git checkout master && git merge >CB<"; }
      gms() { CARE "git checkout staging && git merge >CB<"; }
alias gr='git rebase'
alias gra='git rebase --abort'
alias grao='git remote add origin'
alias grc='git rebase --continue'
alias grl='LESS=-FXRS git reflog'
alias grm='git rebase master'
alias grr='git remote rm'
alias grv='git remote -v'
      gps() {
        if [[ $# -lt 1 || $1 == -* ]]; then
          CARE ">PC< git push origin >CB< $@";
        else
          CARE ">PC< git push $@";
        fi
      }
      gpl() {
        if [[ $# -lt 1 || $1 == -* ]]; then
          CARE ">PC< git pull origin >CB< $@";
        else
          CARE ">PC< git pull $@";
        fi
      }
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
alias gsm='git submodule'
alias gsma='git submodule add'
alias gsmi='git submodule init'
alias gsms='git submodule status'
alias gsmu='git submodule update'
alias gsp='git stash pop'
alias gss='git stash save'
alias gsv='git stash show -p'
alias gt='git tag'
alias gz='git reset'
alias gzh='CARE "git reset --hard"'
alias gzp='git reset -p'
