#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
#
# exec means that this is the last command & the shell can exit

DEFAULT_SESSION=dwm
ECHO_PREFIX='(::)'
SH_PATH="/home/rob/sh/"



startStuff(){
	echo "$ECHO_PREFIX startStuff()"

	#Keyboard control, repeat delay and repeat rate
	#/usr/bin/xset r rate 200 30

	#Pointer control, acceleration and threshold
	#/usr/bin/xset m 30/10 4

	xsetroot -d :0 -cursor_name left_ptr
	${SH_PATH}x_kbd_rate.sh &> /dev/null # this prints out some bs error
	#urxvtd -q -f -o &> /dev/null # -f: fork to bg, -o: open connection to X server (basically makes urxvtd end when the X server goes down)
	#tilda &> /dev/null

	setxkbmap gb
	setxkbmap -option caps:escape # remap
}

dwmStuff(){
	tilda >& /dev/null &
	randomwallpaper.sh
	#nitrogen --restore
	#trayer --edge right --align center --widthtype pixel --width 24 --heighttype pixel --height 24 --SetDockType true --expand true --alpha 5 &
	#stalonetray

	~/bin/dwm/dwm_run.sh
}


cd ~
echo $ECHO_PREFIX "Parameter: \"$1\""
case $1 in
	dwm)
		echo "$ECHO_PREFIX Starting dwm..."
		startStuff
		dwmStuff
		;;

	compiz)
		echo "$ECHO_PREFIX Starting compiz..."
		startStuff nocompmgr
		#compiz-deskmenu&
		exec fusion-icon ;;

	*)
		echo "$ECHO_PREFIX Starting default - \"$DEFAULT_SESSION\""
		startStuff
		if [ "$DEFAULT_SESSION" == "dwm" ]
		then
			echo "$ECHO_PREFIX (jumping to dwmStuff)"
			dwmStuff
		else
			exec $DEFAULT_SESSION
		fi
		;;

#	wmii) exec wmii ;;
#	xmonad) exec xmonad ;;
esac
