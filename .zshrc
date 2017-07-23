alias :q=exit
alias g=git
alias l=ls
alias ll="ls -l"
alias t=tmux
alias gr="grep --color=auto"
alias grr="gr -r --exclude-dir=.git"

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
