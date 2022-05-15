# Check for an interactive session
[ -z "$PS1" ] && return

# bash (i.e. not sh)
#[ -z "$BASH_VERSION" ] && return

# simpler prompt:
__ps1_exitcode(){
	__e=$?
	if [[ $__e -ne 0 ]]
	then printf '%s? ' $__e
	fi
}
__ps1_jobs(){
	__n=$(jobs 2>/dev/null | grep -c '^')
	if [[ $__n -gt 0 ]]
	then printf '%s& ' $__n
	fi
}
__ps1_hostname=$(hostname | tr '[A-Z]' '[a-z]' | tr -d '\n')

# simpler prompt:
export PS1='
\[\e[1m\]${__ps1_hostname}\[\e[0m\] \[\e[0;31m\]$(__ps1_exitcode)\[\e[0;33m\]$(__ps1_jobs)\[\e[1;32m\]$\[\e[0;0m\] '

bind -m vi-insert '"\C-L": clear-screen'

bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
bind -m emacs-standard '"\e[B": history-search-forward'
bind -m emacs-standard '"\e[A": history-search-backward'
set -o vi

complete -d cd rmdir

shopt -s checkjobs # don't exit 1st time if jobs running
shopt -u direxpand # don't expand ~/ (etc) when tabbing
shopt -u hostcomplete # don't treat @<...> as hostname expansion
shopt -s huponexit # sighup children on exit
shopt -s nocaseglob # case insensitive filename expansion

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export HISTCONTROL=erasedups:ignorespace:ignoredups
export HISTTIMEFORMAT="%s (%F %T)"
shopt -s histappend # append to HISTFILE on exit, instead of overwrite
#shopt -s histverify # on enter, load the history entry but don't execute
shopt -s histreedit # if history substitution fails, allow re-editing
shopt -s checkwinsize # update $LINES and $COLUMNS after each command

export HISTSIZE=2000
export HISTFILESIZE=5000

# disable ctrl-n and ctrl-p
bind '"": '
bind '"": '
