# Check for an interactive session
[ -z "$PS1" ] && return

source ~/.aliases
source ~/.environ

export PS1='
\[[1;$(__e=$?; if test $__e -eq 0; then printf 32m; else printf 31m; fi; exit $__e)\]$? \j \[[32m\]$\[[0m\] '

complete -d cd rmdir
bind 'set match-hidden-files off'
bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
bind -m emacs-standard '"\e[B": history-search-forward'
bind -m emacs-standard '"\e[A": history-search-backward'
set -o vi

complete -d cd rmdir

alias ls='ls --color'
alias grep='grep --color'

export HISTCONTROL=erasedups:ignorespace:ignoredups
export HISTTIMEFORMAT="%s (%F %T)"
shopt -s histappend

export HISTSIZE=2000
export HISTFILESIZE=5000

# disable ctrl-n and ctrl-p
bind '"": '
bind '"": '

set vi-cmd-mode-string \1\e[2 q\2
set vi-ins-mode-string \1\e[5 q\2
#set vi-cmd-mode-string '[2 q'
#set vi-ins-mode-string '[6 q'

#set show-mode-in-prompt on

#bashrc_cursor_block(){
#	printf '\x1b[2 q'
#}
#bashrc_cursor_bar(){
#	printf '\x1b[6 q'
#}
