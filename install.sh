#!/bin/bash

if [[ -e ~/.zshrc ]]; then
  RC=~/.zshrc
else
  RC=~/.bashrc
fi

if [[ "`sed --version 2>&1`" == *"GNU"* ]]; then
  SEDI='sed -i'
else
  SEDI='sed -i ""'
fi

cp git.sh ~/.git.sh
cp docker.sh ~/.docker.sh
cp tmux.sh ~/.tmux.sh
cp misc.sh ~/.misc.sh

${SEDI} \
  -e '/.git.sh/d' \
  -e '/.docker.sh/d' \
  -e '/.misc.sh/d' \
  -e '/.tmux.sh/d' \
  ${RC}

echo "source ~/.git.sh" >> ${RC}
echo "source ~/.docker.sh" >> ${RC}
echo "source ~/.misc.sh" >> ${RC}
echo "source ~/.tmux.sh" >> ${RC}
echo -e "\033[1mRun \`source ${RC}\` to apply new aliases!\033[0m"
