# vim:set et ts=2 sw=2 sts=2 ft=sh:

CURRENT=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
source $CURRENT/common_rc

autoload -U compinit promptinit
compinit
promptinit
prompt walters
bindkey -e
