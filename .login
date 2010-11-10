# vim: ft=sh

black="\e[0;30m"
red="\e[0;31m"
green="\e[0;32m"
brown="\e[0;33m"
blue="\e[0;34m"
purple="\e[0;35m"
cyan="\e[0;36m"
gray="\e[0;37m"
nocolor="\e[0;0m"

BLACK="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
BROWN="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
GRAY="\e[1;37m"

export LESS_TERMCAP_mb=$'\e[0;32m'
export LESS_TERMCAP_md=$'\e[0;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;34m'

#export CC
#export CFLAGS
#export CXXFLAGS

export PREFIX="/usr/local/"

export EDITOR="vim"
export VISUAL="vim" #gvim
export BROWSER="browser"
export XTERM="urxvt"
export ESCDELAY=10 # ncurses escape wait time (ms)
export PAGER="less"

if [ "x$TERM" = "xxterm"  ]
then export TERM="xterm-256color"
elif [ "x$TERM" = "xscreen" ]
then export TERM="screen-256color"
fi

# history notes
# echo one two three
# echo !:n
# will echo the nth arg, 0 = echo, 1 = one, 2 = two
# echo !:$ = last, !:^ = first (1)
