# Check for an interactive session
[ -z "$PS1" ] && return

source ~/.aliases
source ~/.environ

export PS1='
\[[1;$(e=$?; if test $e -eq 0; then printf "32m"; else printf "31m"; fi; exit $e)\]$? \j \[[32m\]$\[[0m\] '

complete -d cd rmdir
bind 'set match-hidden-files off'
bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
set -o vi

complete -d cd rmdir

alias ls='ls --color'
alias grep='grep --color'

export HISTCONTROL=erasedups:ignorespace:ignoredups
shopt -s histappend

# disable ctrl-p
bind '"": '
