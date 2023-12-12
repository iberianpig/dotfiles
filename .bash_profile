#/usr/sbin
export PATH="/usr/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# config
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# # golang
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin

# java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# npm
export PATH=~/.npm-global/bin:$PATH

# yarn
export PATH=~/.yarn/bin:$PATH


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
export GTAGSCONF=~/.globalrc
export GTAGSLABEL=pygments

# rbenv
# NOTE: should be placed on ~/.bashrc
if [ -e "$HOME/.rbenv/bin" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

  

# direnv
eval "$(direnv hook bash)"

# less
export LESS='-iMR'
export MANPAGER='less -iMR'

# shellcheck disable=SC2046
# Quote this to prevent word splitting.
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
  linux)
    export LANG="C"
    export LANGUAGE="C"
    export LC_MESSAGES="C"
    export LC_CTYPE="C"
    export LC_COLLATE="C";;
  *)
    export LANG="ja_JP.UTF-8"
    export LANGUAGE="ja:en_GB:en"
    export LC_MESSAGES="ja_JP.UTF-8"
    export LC_CTYPE="ja_JP.UTF-8"
    export LC_COLLATE="ja_JP.UTF-8";;
esac

export PATH="$HOME/.cargo/bin:$PATH"

if [ -e "~/.nix-profile/etc/profile.d/nix.sh" ]; then . "~/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer

export PATH="$HOME/flutter/bin:$PATH"

if [ -e "$HOME/.ghq/github.com/tfutils/tfenv/bin/" ]; then export PATH="$HOME/.ghq/github.com/tfutils/tfenv/bin/:$PATH"; fi

# gyazo-gif
[ -f $HOME/.ghq/github.com/mpsijm/gyazo-gif-for-linux/gyazo-gif ] && export PATH="$HOME/.ghq/github.com/mpsijm/gyazo-gif-for-linux:$PATH"

# linuxbrew
if [ -e "$HOME/linuxbrew/.linuxbrew/bin/brew" ]; then 
  eval "$($HOME/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH="$HOME/.vim/plugged/fzf/bin/:$PATH"
export BYOBU_CONFIG_DIR="$HOME/.config/byobu"

export DENO_INSTALL="/home/iberianpig/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
