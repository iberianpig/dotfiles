#/usr/sbin
export PATH="/usr/sbin:$PATH"

# golang
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
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

# hub command
eval "$(hub alias -s)"

#zenkaku
export VTE_CJK_WIDTH=1

# editor
export EDITOR="/usr/bin/vim"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
