#!/bin/sh

export LANG=en_GB.UTF8

old_umask=$(umask)
umask 066
exec > /tmp/xsession.$USER.$$ 2>&1 < /dev/null
umask $old_umask

cd

xrdb -override ~/.Xdefaults &

if ! pidof gpg-agent >/dev/null
then DISPLAY= gpg-agent --daemon > ~/.ssh/gpg_env_agent &
fi

if ! pidof ssh-agent > /dev/null
then "$HOME/.ssh/agent-init" &
fi

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/bin"

if test -d "$HOME/sh"
then export PATH="$PATH:$HOME/sh"
fi

.screenlayout/triple-desk.sh

~/src/Suckless/wmname/wmname LG3D &

~/code/keynav/keynav.sh -f &
#nohup ~/src/Suckless/xbanish/xbanish >/dev/null 2>&1 &

while :
do
	DISPLAY= pulseaudio
	echo >&2 "$(date +%Y-%m-%dT%H:%M) [xsession] restarting pulseaudio..."
	sleep 2
done &

#yeahconsole &
#unclutter &
randomwallpaper.sh &

dwm="$HOME/src/Suckless/dwm/extra"
. $dwm/env

# load agents
. ~/.environ_interactive

# must be after ". env"
nohup ~/src/Suckless/dwm/extra/dwm_bar.ln >/dev/null 2>&1 &

#nohup redshift -l 54.984497:-1.659193 -t 5500K:4200K >/dev/null 2>&1 &

#mpd &

# firefox horizontal scrolling from shift+scroll:
#xbindkeys

# sync clipboards
autocutsel -f -s PRIMARY
autocutsel -f
nohup env CM_MAX_CLIPS=10 clipmenud >/dev/null 2>&1 &

# attempted fix for xrandr not being picked up by dwm, Sun 14 May 10:42:55 BST 2017
# moved to just below invoking dwm, Fri 15 Jan 09:54:22 GMT 2021
# bumped to 3s, Tue 15 Jun 07:44:15 BST 2021
sleep 3

# run this last, so these settings aren't overwritten
__xsession_xsetup(){
	xset b off # bell

	xset r rate 200 25 # keyboard rate

	xset m 3 1 # mouse speed

	xset s off # screensaver

	xset -b # disable pcspkr

	setxkbmap gb
	#setxkbmap dvorak/dvorak
	#setxkbmap gb -variant colemak
	setxkbmap -option caps:escape

	#xsetroot -d :0 -cursor_name left_ptr

	test -e ~/.Xmodmap && xmodmap ~/.Xmodmap
}
__xsession_xsetup &

exec $dwm/dwm_run.sh
