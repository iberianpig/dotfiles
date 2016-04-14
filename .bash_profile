#/usr/sbin
export PATH="/usr/sbin:$PATH"

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# #genymotion
# export PATH="/opt/genymotion:$PATH"
#
# #android-sdk
# export PATH="/usr/share/android-studio/data/sdk:$PATH"
# export PATH="/usr/share/android-studio/data/sdk/platform-tools:$PATH"
# export PATH="/usr/share/android-studio/data/sdk/tools:$PATH"

#hub command
eval "$(hub alias -s)"

#zenkaku
export VTE_CJK_WIDTH=1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
