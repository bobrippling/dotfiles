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
  urxvtd -q -f -o &> /dev/null # -f: fork to bg, -o: open connection to X server (basically makes urxvtd end when the X server goes down)
  #tilda &> /dev/null

  setxkbmap -option caps:escape # remap
}

dwmStuff(){
  tilda &> /dev/null &
  #nitrogen --restore
  randomwallpaper.sh
  #trayer --edge right --align center --widthtype pixel --width 24 --heighttype pixel --height 24 --SetDockType true --expand true --alpha 5 &
  #stalonetray

  count=0
  while true
  do
    xsetroot -name "$($HOME/sh/vol.sh|dbar -w 12 -nonl -s =; echo -n " "; echo \[`date '+%a %b %Y/%m/%d %T'`\])" # -nonl on dbar to get rid of the new line
    ((count++))
    if [ $count -gt 240 ]
    then
      # 360 = (60 * 60 / 3) / 5, aka change every third of an hour
      #       ^- seconds -^
      randomwallpaper.sh
      count=0
    fi
    sleep 5
  done&

  ~/bin/dwm/rundwm.sh
}


cd ~
echo $ECHO_PREFIX "Parameter: \"$1\""
case $1 in
  dwm)
    echo "$ECHO_PREFIX Starting dwm..."
    startStuff
    dwmStuff
    ;;

  awesome)
    echo "$ECHO_PREFIX Starting awesome..."
    startStuff
    exec awesome ;;

  xfce)
    echo "$ECHO_PREFIX Starting xfce4..."
    startStuff
    exec startxfce4 ;;

  xterm)
    echo "$ECHO_PREFIX Starting xterm..."
    startStuff
    exec xterm ;;

  twm)
    echo "$ECHO_PREFIX Starting twn..."
    startStuff
    exec twm ;;

  mwm)
    echo "$ECHO_PREFIX Starting mwm..."
    startStuff
    exec mwm ;;

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

#  wmii) exec wmii ;;
#  xmonad) exec xmonad ;;
esac
