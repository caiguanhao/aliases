alias npm='npm --loglevel http'
alias npmtb='npm --registry=https://registry.npm.taobao.org --disturl=https://npm.taobao.org/dist'

alias npm='npm --loglevel http'

unalias grepm 2>/dev/null
alias grepm='grep --exclude-dir={node_modules,bower_components,dist,.bzr,.cvs,.git,.hg,.svn,.tmp} --color=always'
