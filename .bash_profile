#/usr/sbin
export PATH="/usr/sbin:$PATH"

# # golang
# export GOROOT=/usr/lib/go
# export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


# npm
export PATH=~/.npm-global/bin:$PATH


# #genymotion
# export PATH="/opt/genymotion:$PATH"
#
# #android-sdk
# export PATH="/usr/share/android-studio/data/sdk:$PATH"
# export PATH="/usr/share/android-studio/data/sdk/platform-tools:$PATH"
# export PATH="/usr/share/android-studio/data/sdk/tools:$PATH"

#zenkaku
export VTE_CJK_WIDTH=1

# editor
export EDITOR="vim"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# gnu gobal
export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=pygments

# rbenv
# NOTE: should be placed on ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook bash)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# less
export LESS='-iMR'
export MANPAGER='less -iMR'
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# gtags
export GTAGSLABEL=pygments


# locale
case "$TERM" in
#  linux)
#    export LANG="C"
#    export LANGUAGE="C"
#    export LC_MESSAGES="C"
#    export LC_CTYPE="C"
#    export LC_COLLATE="C";;
   *)
    export LANG="ja_JP.UTF-8"
    export LANGUAGE="ja:en_GB:en"
    export LC_MESSAGES="ja_JP.UTF-8"
    export LC_CTYPE="ja_JP.UTF-8"
    export LC_COLLATE="ja_JP.UTF-8";;
esac

# reconnect dbus
export $(dbus-launch)
