# Check for an interactive session
[ -z "$PS1" ] && return

# simpler prompt:
__ps1_exitcode(){
	__e=$?
	if [[ $__e -ne 0 ]]
	then printf '\e[0;31m%s?\e[0;0m ' $__e
	fi
	exit $__e
}
__ps1_jobs(){
	__n=$(jobs 2>/dev/null | grep -c '^')
	if [[ $__n -gt 0 ]]
	then printf '\e[0;33m%s&\e[0;0m ' $__n
	fi
}
__ps1_hostname=$(printf '\e[1m'; hostname | tr '[A-Z]' '[a-z]' | tr -d '\n'; printf '\e[0m')

# simpler prompt:
export PS1='
${__ps1_hostname} $(__ps1_exitcode)$(__ps1_jobs)\[\e[1;32m\]$\[\e[0;0m\] '


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
