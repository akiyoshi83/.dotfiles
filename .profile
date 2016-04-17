# vim:set et ts=2 sw=2 sts=2 ft=sh:

# alias
alias profile='source $HOME/.dotfiles/.profile'
alias bashrc='vim ~/.bashrc'
alias zshrc='vim ~/.zshrc'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias p='ps -f'
alias sortnr='sort -n -r'

function repos {
    local dir="$( ghq list -p | peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
}

# environment
if [ -e $HOME/.dotfiles/.profile.env ]; then
  source $HOME/.dotfiles/.profile.env
fi

if [ `which vim` ]; then
  export EDITOR=`which vim`
fi

if [ `which go` ]; then
  export GOPATH=$HOME
  export PATH=$PATH:$GOPATH/bin
fi

if [ `which rbenv` ]; then
  eval "$(rbenv init -)"
fi

if [ `which pyenv` ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if [ -e $HOME/.nodebrew/current/bin ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# Java
export JAVA_HOME6=$(/usr/libexec/java_home -v 1.6 2>/dev/null)
export JAVA_HOME7=$(/usr/libexec/java_home -v 1.7 2>/dev/null)
export JAVA_HOME8=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
export JAVA_HOME=$JAVA_HOME7
export PATH=$JAVA_HOME/bin:$PATH
# Android Studio
export STUDIO_JDK=${JAVA_HOME7%/*/*}

# direnv
eval "$(direnv hook bash)"

# exenv
if [ `which exenv` ]; then
  export PATH="$HOME/.exenv/bin:$PATH"
  eval "$(exenv init -)"
fi


# docker
#export DOCKER_CONTENT_TRUST=1

docker_eval() {
  local machine=$1
  if [ -z $machine ]; then
    machine=$(docker-machine ls | tail -n +2 | peco | cut -d' ' -f1)
  fi
  if [ ! -z $machine ]; then
    eval $(docker-machine env $machine)
  fi
}

docker_rm() {
  local id=$(docker ps -a | tail -n +2 | peco | sed -E -e 's/ +/ /g' | cut -d' ' -f1)
  if [ ! -z "$id" ]; then
    docker rm $id
  fi
}

docker_rmi() {
  local id=$(docker images | tail -n +2 | peco | sed -E -e 's/ +/ /g' | cut -d' ' -f3)
  if [ ! -z "$id" ]; then
    docker rmi $id
  fi
}

docker_rm_exited() {
  docker rm $(docker ps -aqf "status=exited")
}

docker_rmi_dangling() {
  docker rmi $(docker images -aqf "dangling=true")
}

alias dv='docker_eval'
alias di='docker images'
alias dp='docker ps'
alias da='docker ps -a'
alias dx='docker exec'
alias dr='docker_rm'
alias dri='docker_rmi'
alias dc='docker-compose'
alias dm='docker-machine'

amazon-linux() {
  aws ec2 describe-images --filter "Name=name,Values=amzn-ami-hvm-2015.09.2.x86_64-gp2" \
    --region ap-northeast-1 --query "Images[].ImageId" --output text | tr -d [:space:]
}

cf-active-stacks() {
 aws cloudformation list-stacks --stack-status-filter \
   CREATE_FAILED \
   CREATE_COMPLETE \
   ROLLBACK_IN_PROGRESS \
   ROLLBACK_FAILED \
   ROLLBACK_COMPLETE \
   DELETE_IN_PROGRESS \
   DELETE_FAILED \
   UPDATE_IN_PROGRESS \
   UPDATE_COMPLETE_CLEANUP_IN_PROGRESS \
   UPDATE_COMPLETE \
   UPDATE_ROLLBACK_IN_PROGRESS \
   UPDATE_ROLLBACK_FAILED \
   UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS \
   UPDATE_ROLLBACK_COMPLETE \
   $@
}

# [USAGE]
# ec2ssh --region REGION_NAME --profile PROFILE_NAME
ec2ssh() {
  ssh -l ec2-user $( \
    aws ec2 describe-instances \
        --filter "Name=instance-state-name,Values=running" \
        --query "Reservations[].Instances[].[PublicIpAddress,Tags[?Key=='Name'].Value | [0], join(',',Tags[?Key!='Name'].Value)]" \
        --output text \
        ${@} \
        | peco | awk '{print $1}' \
  )
}
