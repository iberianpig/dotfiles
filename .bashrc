# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
# export HISTSIZE=100000                   # big big history
# export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it
#
# # Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export HISTFILE=$HOME/.bash_history

export HISTSIZE=10000                   # big big history
export HISTFILESIZE=100000               # big big history
# HISTCONTROL=ignoreboth:erasedups

# https://piro.sakura.ne.jp/latest/blosxom/webtech/2018-03-04_history-nodup-with-tmux.htm
function share_history {
  history -a
  history -n
}
PROMPT_COMMAND='share_history'

# バックアップ用の関数
function backup_bash_history {
  local backup_dir="${HOME}/.bash_history_backups"
  local timestamp=$(date +%Y%m%d_%H%M%S)

  # バックアップディレクトリが存在しない場合は作成
  [ ! -d "${backup_dir}" ] && mkdir -p "${backup_dir}"

  # バックアップファイル名を設定
  local backup_file="${backup_dir}/.bash_history_${timestamp}.bak"

  # バックアップを作成
  cp "${HISTFILE}" "${backup_file}"
}

function restore_bash_history {
  local backup_dir="${HOME}/.bash_history_backups"
  local backup_file

  # fzf がインストールされているか確認
  if ! command -v fzf > /dev/null; then
    echo "fzf is not installed. Please install it to use this function."
    return 1
  fi

  # バックアップディレクトリが存在しない場合はエラーを表示
  if [ ! -d "${backup_dir}" ]; then
    echo "Backup directory does not exist. No backups available."
    return 1
  fi

  # fzf を使ってバックアップファイルを選択し、プレビューを表示
  backup_file=$(find "${backup_dir}" -type f -name ".bash_history_*.bak" | fzf \
    --preview='echo "Total lines: $(wc -l < {})"; echo ""; tail -n 100 {}' \
    --preview-window=up:70%:wrap)

  # 選択されたバックアップファイルがある場合、現在の履歴ファイルと置き換える
  if [ -n "${backup_file}" ]; then
    cp "${backup_file}" "${HISTFILE}"
    echo "Restored history from ${backup_file}"
    history -c
    history -r
  else
    echo "No backup file selected."
  fi
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# reset language
case $TERM in
      linux) LANG=C ;;
      *)     LANG=us_EN.UTF-8;;
esac

unset color_prompt force_color_prompt

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

## add bash_profile
## see http://itiut.hatenablog.com/entry/2013/07/07/114143

if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

# eval "$(EDITOR=/usr/bin/vim)"
eval "$(SHELL=/bin/bash)"

# reverse search, going forward(ctrl+s)
stty -ixon

if [ "$DISPLAY" ]; then
  xset r rate 200 45
fi


export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_TMUX_HEIGHT="50%"
export FZF_DEFAULT_OPTS="
--color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229
--color info:150,prompt:110,spinner:150,pointer:167,marker:174
"

# include git untracked files without ignored || find
export FZF_DEFAULT_COMMAND='(git ls-files; git ls-files -o --exclude-standard ||
  find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
  sed s/^..//) 2> /dev/null'

if which fzf > /dev/null; then

  fzf-change-repo() {
    local repository

    if [[ -z "${PRIVATE_REPO}" ]]; then
      repository="$(ghq list -p | fzf)"
    else
      repository="$(ghq list -p | grep -v "$PRIVATE_REPO" | fzf)"
    fi

    echo "$repository"

    if [[ -n "$repository" ]]; then
      local dirname
      dirname=$(basename "${repository}")
      cd "${repository}" && tmux rename-window "${dirname}" || return
    fi
  }

  alias cr=fzf-change-repo

  # Markdownのメモを探して開く
  fzf-search-note() {
    local note_path=~/Dropbox/document
    local selected_file="$(find  $note_path/20*.md -type f | fzf --tac)"

    if [ -n "${selected_file}" ]; then
      vi "${selected_file}"
    fi
  }
  alias sn=fzf-search-note

  # Blogのメモを探して開く
  fzf-search-blog() {
    local note_path=~/.ghq/github.com/iberianpig/iberianpig.github.io/content/posts/
    local selected_file="$(find  $note_path/201*.md -type f | fzf --tac)"

    if [ -n "${selected_file}" ]; then
      vi "${selected_file}"
    fi
  }
  alias sb=fzf-search-blog

  function fzf-git-ls-files() {
    # check whether the current directory is under `git` repository.
    if git rev-parse 2> /dev/null; then
      local selected_file="$(git ls-files . | fzf --tac)"

      if [ -n "${selected_file}" ]; then
        vi "${selected_file}"
      fi
    fi
  }
  alias gl=fzf-git-ls-files

  function fzf-kill() {
    local selected=$(ps aux | fzf)
    if [ -n "${selected}" ]; then
      echo "${selected}" | cut -d " " -f 26- | xargs echo 'kill: '
      echo "${selected}" | awk '{print $2}' | xargs kill -9
    fi
  }
  alias pk=fzf-kill

  # tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
  # `tm` will allow you to select your tmux session via fzf.
  # `tm irc` will attach to the irc session (if it exists), else it will create it.
  function fzf-byobu() {
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    if [ "$1" ]; then
      byobu $change -t "$1" 2>/dev/null || (byobu new-session -d -s "$1" && byobu $change -t "$1"); return
    fi
    session=$(byobu list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && byobu $change -t "$session" || echo "No sessions found."
  }
  alias bs=fzf-byobu # bs means byobu-session
fi # fzf

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=normal -i "$([ $? = 0 ] && echo terminal || echo error)" "Task finished" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# remap ctrl-w
stty werase undef
bind '"\C-w":unix-filename-rubout'

# map <Shift-Escape> ~
if [ -n "${DISPLAY+x}" ]; then
  xmodmap -e "keycode 9 = Escape  asciitilde"
fi

eval "$(direnv hook bash)"

if [[ -f "$HOME/.envrc" ]]; then
  source "$HOME/.envrc"
fi

# wakatime
[ -f ~/.ghq/github.com/gjsheep/bash-wakatime/bash-wakatime.sh ] && source ~/.ghq/github.com/gjsheep/bash-wakatime/bash-wakatime.sh

# makef
[ -f ~/.ghq/github.com/iberianpig/makef/makef.sh ] && source ~/.ghq/github.com/iberianpig/makef/makef.sh

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# kubectl
if which kubectl > /dev/null; then
  source <(kubectl completion bash)
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/iberianpig/google-cloud-sdk/path.bash.inc' ]; then . '/home/iberianpig/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/iberianpig/google-cloud-sdk/completion.bash.inc' ]; then . '/home/iberianpig/google-cloud-sdk/completion.bash.inc'; fi


function bwu() {
    BW_STATUS=$(bw status | jq -r .status)
    case "$BW_STATUS" in
    "unauthenticated")
        echo "Logging into BitWarden"
        export BW_SESSION=$(bw login --raw)
        ;;
    "locked")
        echo "Unlocking Vault"
        export BW_SESSION=$(bw unlock --raw)
        ;;
    "unlocked")
        echo "Vault is unlocked"
        ;;
    *)
        echo "Unknown Login Status: $BW_STATUS"
        return 1
        ;;
    esac
    bw sync
}
