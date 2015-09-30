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

