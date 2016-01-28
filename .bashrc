# Check for an interactive session
[ -z "$PS1" ] && return

source ~/.aliases
source ~/.environ

reset_color="\[\e[m\]"
if [ $UID -eq 0 ]
then colour="\[${red}\]"
else colour="\[${green}\]"
fi

export PS1="\n${colour}[${reset_color}\$?${colour}][\[\e[1;34m\]\W${colour}]${reset_color}\\$ "

#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
complete -d cd rmdir
bind 'set match-hidden-files off'
bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
set -o vi
