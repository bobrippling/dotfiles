#!/bin/sh

exec > /tmp/startx.out 2>&1 < /dev/null

cd

xrdb -override ~/.Xdefaults

nohup pulseaudio -D > /dev/null 2>&1 &

px=`expr 1440 / 2 - 40`
py=`expr 1440 / 2 - 7`
xterm -g 80x15+$px+$py -e "$HOME/sh/rcmpd.sh; $HOME/.ssh/ssh-agent-auto.sh"

. ~/.login

xsetroot -d :0 -cursor_name left_ptr
xsetup.sh

vol.sh front_on
vol.sh headphone_off

dwm="$HOME/src/Suckless/dwm/extra"
. $dwm/env

yeahconsole &
#unclutter &
randomwallpaper.sh

exec $dwm/dwm_run.sh
