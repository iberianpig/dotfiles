# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -hA'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# bunder
alias be='bundle exec'

# apt-get
alias api='sudo apt-get install'
alias apd='sudo apt-get update'
alias apg='sudo apt-get update && sudo apt-get upgrade'

alias ag='ag -S --skip-vcs-ignores'
alias agh='ag --hidden'

# tw
alias tw='tw -yes'

# mozc
alias mozc-config="/usr/lib/mozc/mozc_tool -mode=config_dialog"
alias mozc-dict="/usr/lib/mozc/mozc_tool --mode=dictionary_tool"

# search markdown and open with vim
alias 'md'='vim ./*.md'

dic () {
  w3m "http://ejje.weblio.jp/content/$1" | grep "用例"
}

alias vi='vim'
