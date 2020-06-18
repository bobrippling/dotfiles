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
then "$HOME/.ssh/ssh-agent-auto.sh" &
fi

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/sh"

__xsession_monitors(){
	# two monitor setup
	#xrandr --output DP-0 --left-of DVI-I-0

	# two monitor setup
	xrandr --output DP-0 --left-of HDMI-0

	sleep 2 # attempted fix for xrandr not being picked up by dwm, Sun 14 May 10:42:55 BST 2017
}
__xsession_monitors

~/src/Suckless/wmname/wmname LG3D &

~/code/keynav/keynav.sh -f &
#nohup ~/src/Suckless/xbanish/xbanish >/dev/null 2>&1 &

#xsetroot -d :0 -cursor_name left_ptr
~/code/bin/sh/xsetup.sh &

#yeahconsole &
#unclutter &
randomwallpaper.sh &

dwm="$HOME/src/Suckless/dwm/extra"
. $dwm/env

# must be after ". env"
#nohup ~/src/Suckless/dwm/extra/dwm_bar.ln >/dev/null 2>&1 &
nohup ~/src/Suckless/dwm/extra/dwm_bar.pc >/dev/null 2>&1 &

#nohup redshift -l 54.984497:-1.659193 -t 5500K:4200K >/dev/null 2>&1 &

#mpd &

# firefox horizontal scrolling from shift+scroll:
#xbindkeys

# sync clipboards
autocutsel -s PRIMARY &
autocutsel &

exec $dwm/dwm_run.sh
