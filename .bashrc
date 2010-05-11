# Check for an interactive session
[ -z "$PS1" ] && return

source ~/.login
source ~/.aliases

#PS1='[\u@\h \W]\$ '
#PS1="\n${gray}[$?:${green}\u${gray}@${green}\h:\W${gray}]\\$ "
reset_color="\e[0m"
export PS1="\n${green}[${reset_color}${?}${green}][\e[1;34m\W${green}]${reset_color}\\$ "

#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
bind -m vi '"j": history-search-forward'
bind -m vi '"k": history-search-backward'
set -o vi
