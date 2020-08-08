# vim:set et ts=2 sw=2 sts=2 ft=sh:

CURRENT=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
source $CURRENT/common_rc

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