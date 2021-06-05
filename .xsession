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

__xsession_monitors(){
	# two monitor setup
	#xrandr --output DP-0 --left-of DVI-I-0

	# two monitor setup
	xrandr --output DP-0 --left-of HDMI-0
}
__xsession_monitors

~/src/Suckless/wmname/wmname LG3D &

~/code/keynav/keynav.sh -f &
#nohup ~/src/Suckless/xbanish/xbanish >/dev/null 2>&1 &

while :
do
	DISPLAY= pulseaudio
	echo >&2 "$(date +%Y-%m-%dT%H:%M) [xsession] restarting pulseaudio..."
	sleep 1
done &

#xsetroot -d :0 -cursor_name left_ptr
__xsession_xsetup(){
	xset b off # bell

	xset r rate 200 25 # keyboard rate

	xset m 3 1 # mouse speed

	xset s off # screensaver

	setxkbmap gb
	#setxkbmap dvorak/dvorak
	setxkbmap -option caps:escape

	test -e ~/.Xmodmap && xmodmap ~/.Xmodmap
}
__xsession_xsetup &

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

# attempted fix for xrandr not being picked up by dwm, Sun 14 May 10:42:55 BST 2017
# moved to just below invoking dwm, Fri 15 Jan 09:54:22 GMT 2021
sleep 2

exec $dwm/dwm_run.sh
