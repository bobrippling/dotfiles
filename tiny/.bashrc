export PS1='
\[[1;$(__e=$?; if test $__e -eq 0; then printf 32m; else printf 31m; fi; exit $__e)\]$? \j \$\[[0m\] '

bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
set -o vi

complete -d cd rmdir

alias ls='ls --color'
alias grep='grep --color'

export HISTCONTROL=erasedups:ignorespace:ignoredups
shopt -s histappend

export HISTSIZE=2000
export HISTFILESIZE=5000

# disable ctrl-n and ctrl-p
bind '"": '
bind '"": '
