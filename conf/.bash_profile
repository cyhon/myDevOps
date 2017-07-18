export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='Exfxcxdxbxegedabagacad'

alias ll='ls -al'
alias dc='docker-compose'
alias dps='docker ps'
alias hp="export http_proxy=127.0.0.1:1087 && export https_proxy=127.0.0.1:1087"
alias uhp="unset http_proxy https_proxy"

#export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_77.jdk/Contents/Home'
#export PATH=/opt/apache-maven-3.3.9/bin:$PATH
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
source ~/.git-prompt.sh
export PS1='\[\033[36m\]\w$(__git_ps1 " \[\033[35m\]{\[\033[32m\]%s\[\033[35m\]}")\[\033[34m\]$\[\033[0m\] '
