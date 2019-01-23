# export default editors
export EDITOR="vim"
export SVNEDITOR=${EDITOR}

export PATH="$HOME/.local/bin:$PATH"

# unset TMUX so I can run nested sessions without having to always unset it manualy
unset TMUX

# Define pager. Some programs (like psql on centos6) default to
# PAGER=more which has weird keybindings. Less is more natural to use for
# me as vim user.
export PAGER=less

# fix javashits rendering
# https://github.com/xmonad/xmonad/issues/126
export _JAVA_AWT_WM_NONREPARENTING=1

# set zshzle to vi mode
setopt VI

# error if file generation has no matches
# override with setopt NULL_GLOB
setopt nomatch

# If  a  command  is issued that can't be executed as a normal command,
# and the command is the name of a directory, perform the cd command to
# that directory
setopt auto_cd

# warn about background jobs when exiting
setopt checkjobs

# do not kill background processes when exiting.
setopt nohup

# autoload zargs to avoid writing some for loops
autoload -U zargs

# print timing statistics for commands that take more then a second of
# combined user and system execution time.
REPORTTIME=1

# add user-local path to paths to autoload functions from
fpath=($HOME/.zsh/functions $fpath)

# disable XON/XOFF to prevent fat fingers from Ctrl-s hanging the terminal.
# fyi Ctrl-q resumes after ctrl-s. See
# https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# load my custom prompt theme
autoload -Uz promptinit
promptinit
prompt yac

function in_tmux() {
  # no pane -> no tmux
  [[ -z "${TMUX_PANE}" ]] && return 1
  return 0
}

function set_tmux_window_name {
  # Set the window name to the full command
  # This is helpfull when
  # 1. ssh <hostname>
  # 2. looking at multiple man pages
  # might be troulesome with long commands but the occasional long command
  # (mostly ad-hoc oneliner scripts that would take up to 20 lines if
  # written as proper script) has not bothered me in a year of using this
  # code.
  in_tmux || return 0
  [[ -z ${TMUX_WINDOW_NAME} ]] || return 0
  # user requested fixed window name by exporting TMUX_WINDOW_NAME
  # -> NOOP and success exit.

  tmux rename-window -t${TMUX_PANE} "$1"
}
add-zsh-hook preexec set_tmux_window_name
function reset_tmux_window_name {
  # resets window name back to "zsh" after a command finishes, to
  # overwrite name given by `set_tmux_window_name`.
  in_tmux || return 0
  wname="zsh"

  [[ -z ${TMUX_WINDOW_NAME} ]] || {
    # user requested fixed window name by exporting TMUX_WINDOW_NAME and
    # window name hasn't changed since last time -> successfull exit.
    #
    # This can not be implemented with simple bool flag to disable this
    # hooks as that causes the client code to 1. disable the hooks and 2.
    # reset the names again; where we get a race as first step still fires
    # off the hooks which race against the second step.
    #
    # So instead of bool flag, take the intended window name, if it is
    # non-empty and changed since last run, set it. Otherwise noop exit.
    declare -g __LAST_TMUX_WINDOW_NAME
    [[ ${__LAST_TMUX_WINDOW_NAME:-} != ${TMUX_WINDOW_NAME} ]] || return 0

    # re-set wname to the fixed one and continue with setting it.
    wname="${TMUX_WINDOW_NAME}"
  }

  tmux rename-window -t${TMUX_PANE} "$wname"
}
add-zsh-hook precmd reset_tmux_window_name

# show menu if more than just 1 completion item is available
zstyle ':completion:*' menu select=2

# expand .. to ../
zstyle ':completion:*' special-dirs true

if [[ "$TERM" != emacs ]]; then
    # fix home/end/del keys
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line

    [[ -z "$terminfo[khome]" ]] || bindkey -M viins "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M viins "$terminfo[kend]" vi-end-of-line
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M viins "$terminfo[kdch1]" vi-delete-char

    # ncurses fogyatekos
    [[ "$terminfo[khome]" == "^[O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]" == "^[O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
fi

os=$(uname)

# default overrides

# Enable colored `ls` output when stdout is connected to a terminal.
[[ $os = "Linux" ]] && alias ls="command ls --color=auto"
[[ $os = "FreeBSD" ]] && export CLICOLOR=

alias grep="command grep --color=auto"

# shortcuts
alias :q=exit
alias d=docker
alias g=git
alias gr=grep
alias l=ls
alias s=systemctl
alias t=tmux

# shortcuts for common arguments
alias ll="ls -l"
alias grr="grep -r --exclude-dir=.git --exclude-dir=.tox"

# shortcuts for grepping media files
alias gr_video="grep -iE '(avi|flv|mkv|wmv|mpg|mpeg|mp4)'"
alias gr_pics="grep -iE '(jpg|jpeg|tiff|bmp|png|gif)'"

# shortcut for packing linux initramfs
alias packinitramfs="cpio --quiet -o -H newc | gzip -9 "

# shortcut to gphoto2 for my camera
alias gp2eos="gphoto2 --camera \"Canon EOS 350D\""

# enable tab-completion
autoload -Uz compinit
compinit

HISTFILE=~/.local/share/zsh/history

# Zsh does not provide a way to set unlimited history, which I want for
# the history file, so I need to use a reasonably unreachable
# value. The maximum of int32 should do the trick.
#
# Based on the earlist entry in my current 5k entries in history being
# ~25 days ago and taking up 136K of disk space, the int32 maximum should
# hold history over rougly 60 years and take about 116G of disk space.
SAVEHIST=$(echo $(( 2^32 - 1 )))

# For interactive sessions (HISTSIZE) 50k entries should be sufficient,
# taking roughly 1M of memory for each z shell.
HISTSIZE=50000

# prevent parallel sessions from overwriting and probably allow HISTFILE
# smaller than SAVEHIST from limiting SAVEHIST to HISTFILE
setopt append_history

# History is saved in including starting timestamp and execution wall
# clock masurement (extended_history) for later analytics plus ``fc -liD``
# can be very handy.
setopt extended_history

setopt hist_fcntl_lock

# do not save commands leading with space into history
setopt hist_ignore_space

# do not save commands printing the history (fc -l)
setopt hist_no_store

# confirm history expansions before executing
setopt hist_verify

# don't add duplicates into history
setopt histignorealldups

# enable vi like keybinds in Zsh Line Editor
setopt vi

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# exec $EDITOR to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^z' edit-command-line

# run argv with czech locale
function cs {
  local cmd="$1"
  shift
  LANG=cs_CZ.UTF8 $cmd "$@"
}

function wallclock {
    tzs=(
        America/Los_Angeles
        America/New_York
        Brazil/East
        Europe/Prague
        Europe/Berlin
        Asia/Tokyo
    )
    for i in "${tzs[@]}"; do
        printf "%-25s" "${i}"
        TZ="${i}" date "+%a %d %T %:::z"
    done
}

function hl {
  grep --color=auto -e '^' "-e ${^@}"
}

test -f ~/.zshrc2 && . ~/.zshrc2

alias big-urxvt="urxvt -fn 'xft:DejaVu Sans Mono:pixelsize=30:antialias=true:hinting=true'"

function docker-reload {
  docker ps -q | xargs docker kill
  # kill doesn't stop containers that are restarting, rm will do
  docker ps -q | xargs docker rm
  docker container prune -f
}

alias d-reload=docker-reload
