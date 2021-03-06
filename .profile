# vim:set et ts=2 sw=2 sts=2 ft=sh:

# alias
alias profile='source $HOME/.dotfiles/.profile'
alias bashrc='vim ~/.bashrc'
alias zshrc='vim ~/.zshrc'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='ls -FG'
alias l='ls -lFGh'
alias la='ls -lAFG'
alias ll='ls -lFG'
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

alias pserv="python -m SimpleHTTPServer"

alias godoc="godoc -http=localhost:6060 -analysis type -play"

function has {
  which $1 > /dev/null 2>&1
}

function repos {
    local dir="$( ghq list -p | peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
}

# environment
export PATH=$PATH:$HOME/.dotfiles/bin
if [ -e $HOME/.dotfiles/.profile.env ]; then
  source $HOME/.dotfiles/.profile.env
fi

if has vim; then
  export EDITOR=`which vim`
fi

if has go; then
  export GOPATH=$HOME
  export PATH=$PATH:$GOPATH/bin
fi

if has rbenv; then
  eval "$(rbenv init -)"
fi

if has pyenv; then
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
if has direnv; then
  eval "$(direnv hook bash)"
fi

# exenv
if has exenv; then
  export PATH="$HOME/.exenv/bin:$PATH"
  eval "$(exenv init -)"
fi

# now with timezone
now() {
  tzs=(UTC America/Los_Angeles Asia/Tokyo Africa/Cairo Australia/Sydney Europe/Berlin)
  for tz in ${tzs[@]}; do
    TZ=$tz date "+%Y-%m-%dT%H:%M %Z"
  done
}

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
  cond=$1
  id_only=$2
  line=$(aws ec2 describe-images \
    --output json \
    --owner amazon \
    --filter "Name=name,Values=amzn-ami-*${cond}*" \
    | jq  -c ".Images[] | [.ImageId, .VirtualizationType, .RootDeviceType, .Name, .Description]" \
    | sed -e s/,/$'\t'/g \
    | tr -d '\[\]"' \
    | peco)
  if [ ! -z "${id_only}" ]; then
    echo $line | cut -d' ' -f1
  else
    echo $line
  fi
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
  user=${1:-'ec2-user'}
  shift
  selected=$(aws ec2 describe-instances \
    --filter "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].[PublicIpAddress,Tags[?Key=='Name'].Value | [0], join(',',Tags[?Key!='Name'].Value)]" \
    --output text \
    ${@} \
    | peco)
  ssh -l "$user" $(echo -n $selected | awk '{print $1}')
}

default-vpc() {
  aws ec2 describe-vpcs --filter Name=is-default,Values=true --query "Vpcs[].{VpcId:VpcId,CidrBlock:CidrBlock}" --output text
}

vpc-list() {
  aws ec2 describe-vpcs --query "Vpcs[].[Tags[?Key=='Name'].Value | [0],VpcId,CidrBlock]" --output text ${@}
}

subnet-list() {
  aws ec2 describe-subnets --query "Subnets[].[Tag[?Key==Name].Value,VpcId,SubnetId,CidrBlock]" --output text ${@}
}
default-security-group() {
  #awless list securitygroups | grep vpc-d997fcbc | grep "default VPC security group"
  aws ec2 describe-security-groups --filter "Name=description,Values='default VPC security group'" --query SecurityGroups[].[VpcId,GroupId,GroupName,Description] --output text
}

allow-me-ssh() {
  local vpcid=$1
  local gip=$(curl -s http://checkip.amazonaws.com/ | tr -d "\r\n")
  if [ "$vpcid" == "" ]; then
    local vpcid=$(aws ec2 describe-vpcs --filter "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
  fi
  local sgid=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$vpcid,Name=group-name,Values=temp-ssh" --query "SecurityGroups[].GroupId" --output text)
  if [ "$sgid" == "" ]; then
    local sgid=$(aws ec2 create-security-group --vpc-id $vpcid --group-name temp-ssh --description "Temporary ssh security group" --query "GroupId" --output text)
  fi
  for cidr in $(aws ec2 describe-security-groups --filter "Name=group-id,Values=$sgid" --query "SecurityGroups[].IpPermissions[].IpRanges[].CidrIp" --output text); do
    aws ec2 revoke-security-group-ingress --group-id $sgid --protocol tcp --port 22 --cidr $cidr
  done
  aws ec2 authorize-security-group-ingress --group-id $sgid --protocol tcp --port 22 --cidr "${gip}/32"
  echo "$sgid : ${gip}/32"
}

allow-me-rdp() {
  local vpcid=$1
  local gip=$(curl -s http://checkip.amazonaws.com/ | tr -d "\r\n")
  if [ "$vpcid" == "" ]; then
    local vpcid=$(aws ec2 describe-vpcs --filter "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
  fi
  local sgid=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$vpcid,Name=group-name,Values=temp-rdp" --query "SecurityGroups[].GroupId" --output text)
  if [ "$sgid" == "" ]; then
    local sgid=$(aws ec2 create-security-group --vpc-id $vpcid --group-name temp-rdp --description "Temporary rdp security group" --query "GroupId" --output text)
  fi
  for cidr in $(aws ec2 describe-security-groups --filter "Name=group-id,Values=$sgid" --query "SecurityGroups[].IpPermissions[].IpRanges[].CidrIp" --output text); do
    aws ec2 revoke-security-group-ingress --group-id $sgid --protocol tcp --port 3389 --cidr $cidr
  done
  aws ec2 authorize-security-group-ingress --group-id $sgid --protocol tcp --port 3389 --cidr "${gip}/32"
  echo "$sgid : ${gip}/32"
}

allow-port() {
  local port=$1
  if [ "$port" == "" ]; then
    echo port is required
    exit 1
  fi
  local vpcid=$2
  local gip=$(curl -s http://checkip.amazonaws.com/ | tr -d "\r\n")
  if [ "$vpcid" == "" ]; then
    local vpcid=$(aws ec2 describe-vpcs --filter "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
  fi
  local sgid=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$vpcid,Name=group-name,Values=temp-ssh" --query "SecurityGroups[].GroupId" --output text)
  if [ "$sgid" == "" ]; then
    local sgid=$(aws ec2 create-security-group --vpc-id $vpcid --group-name temp-ssh --description "Temporary ssh security group" --query "GroupId" --output text)
  fi
  for cidr in $(aws ec2 describe-security-groups --filter "Name=group-id,Values=$sgid" --query "SecurityGroups[].IpPermissions[].IpRanges[].CidrIp" --output text); do
    aws ec2 revoke-security-group-ingress --group-id $sgid --protocol tcp --port $port --cidr $cidr
  done
  aws ec2 authorize-security-group-ingress --group-id $sgid --protocol tcp --port $port --cidr "${gip}/32"
  echo "$sgid : ${gip}/32 port: $port"
}

cfn-new() {
  cat <<EOS
AWSTemplateFormatVersion: 2010-09-09
Description: ''
Parameters: {}
Mappings: {}
Resources: {}
Outputs: {}
EOS
}

aws-profile() {
  if [ "$AWS_PROFILE" == "" ]; then
    echo "default"
  else
    echo $AWS_PROFILE
  fi
}

change-aws-profile() {
  if [ "$1" == "" ]; then
    local profile=$(cat ~/.aws/config | grep "\[profile" | sed -e "s/\[profile //" | sed -e "s/]$//" | peco)
    export AWS_PROFILE=$profile
  else
    export AWS_PROFILE=$1
  fi
}

regions() {
  aws ec2 describe-regions --region ap-northeast-1 --query "Regions[].RegionName" --output text | sed -e s/$'\t'/$'\\\n'/g
}

region() {
  if [ "$AWS_DEFAULT_REGION" == "" -a -f ~/.aws/config ]; then
    cat ~/.aws/config | grep "\[default\]" -A5 | grep region | sed -e 's/.* = \(.*\)/\1/'
  else
    echo $AWS_DEFAULT_REGION
  fi
}

change-region() {
  if [ "$1" == "" ]; then
    local reg=$(regions | peco)
    export AWS_DEFAULT_REGION=$reg
  else
    export AWS_DEFAULT_REGION=$1
  fi
}

make_bash_stat() {
  local profile=$(aws-profile)
  local region=$(region)
  if [ "$profile" == "" -a "$region" == "" ]; then
    export bash_stat=""
  fi
  export bash_stat="AWS > $profile > $region"
}

PROMPT_COMMAND='make_bash_stat'

simplify_prompt() {
  #export PS1='\h:\W \u\$ '
  export PS1='$ '
}

reset_prompt() {
  export PS1='\h:\W \u $bash_stat\n\$ '
}
reset_prompt
