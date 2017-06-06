[[ $EMACS = t ]] && unsetopt zle

unsetopt promptcr
autoload -Uz vcs_info
autoload colors
colors

##### .zshrc #####
export LANG=ja_JP.UTF-8
export TERM=xterm-256color
export SVN_EDITOR=emacs

### path
export PATH=$PATH:/bin
export PATH=$PATH:/sbin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:~/bin

export MANPATH=/usr/share/man:/usr/X11R6/man:/usr/local/mana

### GHE
export GITHUB_HOST='github.com'
export GITHUB_USER='tehepero'

### Pivotal
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

### prompt
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

RPROMPT="%1(v|%F{green}%1v%f|)"

local GREEN="%{${fg[green]}%}"
local YELLOW="%{${fg[yellow]}%}"
local RED="%{${fg[red]}%}"
local END="%{${reset_color}%}"
PROMPT="[$GREEN%n$END@$RED${HOST}$END%f:$YELLOW%~$END]"$'\n'"$ "

#RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ? "

## keybind
bindkey -e

### alias
alias ls='ls -Ghla'

if [ "$(uname)" = 'Darwin' ]; then
    # MacOSX
    emacs_path="/usr/local/bin/emacs-24.5"
    alias emacs_server-start="$emacs_path -daemon"
    alias emacs_server-stop="$emacs_path -e \"(kill-emacs)\""
    alias emacs_server-restart='/usr/local/bin/emacsclient -e "(kill-emacs)"; /usr/local/bin/emacs-24.5 -daemon'
    alias emacs='/usr/local/bin/emacsclient -nw'
else
    alias emacs_server-start='emacs -daemon'
    alias emacs_server-stop='emacsclient -e "(kill-emacs)"'
    alias emacs_server-restart='emacsclient -e "(kill-emacs)"; /home/y/bin64/emacs -daemon'
    alias emacs='emacsclient -nw'
fi

## auto change directory
setopt auto_cd
function chpwd() { ls }

### auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

### command correct edition before each completion attempt
#setopt correct

### compacked complete list display
setopt list_packed

### no beep sound when complete list displayed
setopt nolistbeep

### glob extend
setopt extended_glob

### history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups     # ignore duplication command history list
setopt hist_reduce_blanks   # reduce blanks history list
setopt share_history        # share command history data

### historical search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt always_last_prompt
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt list_packed
setopt list_types


function reload() {
    source $HOME/.zshrc
}

function dired () {
    emacs -e "(dired \"$PWD\")"
}

function cde () {
    EMACS_CWD=`emacsclient -e "
     (expand-file-name
      (with-current-buffer
          (nth 1
               (assoc 'buffer-list
                      (nth 1 (nth 1 (current-frame-configuration)))))
        default-directory))" | sed 's/^"\(.*\)"$/\1/'`

    echo "chdir to $EMACS_CWD"
    cd "$EMACS_CWD"
