# Check for an interactive session
[ -z "$PS1" ] && return

__prompt_command(){
	__e=$?
	PS1=

	PS1+='\[\e[1m\]'
	PS1+='\h '
	PS1+='\[\e[0m\]'

	if [[ $__e -ne 0 ]]
	then
		PS1+='\[\e[0;31m\]'
		PS1+="${__e}?"
		PS1+='\[\e[0;0m\] '
	fi

	if type jobs >/dev/null 2>&1 \
		&& __n=$(jobs 2>/dev/null | grep -c '^') \
		&& [[ $__n -gt 0 ]]
	then
		PS1+='\[\e[0;33m\]'
		PS1+="$__n&"
		PS1+='\[\e[0;0m\] '
	fi

	PS1+='\[\e[1;32m\]'
	PS1+='\$'
	PS1+='\[\e[0;0m\] '
}

export PROMPT_COMMAND="__prompt_command; $PROMPT_COMMAND"

# simpler prompt:
#export PS1='
#\[\e[1;$(__e=$?; if test $__e -eq 0; then printf 32m; else printf 31m; fi; exit $__e)\]$? \j \[\e[32m\]$\[\e[0m\] '


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
