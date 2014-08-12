# vim:set et ts=2 sw=2 sts=2 ft=sh:

# alias
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias profile='source $HOME/dotfiles/profile'

# environment
if [ -e $HOME/dotfiles/.profile.env ]; then
  source $HOME/dotfiles/.profile.env
fi

if [ -f /usr/bin/vim ]; then
  export EDITOR=/usr/bin/vim
fi

