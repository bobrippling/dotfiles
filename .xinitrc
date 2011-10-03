#!/bin/sh

cd

xsetroot -d :0 -cursor_name left_ptr

xsetup.sh

dwm="$HOME/src/Suckless/dwm/extra"
. $dwm/env

yeahconsole &
#unclutter &
randomwallpaper.sh

exec $dwm/dwm_run.sh
