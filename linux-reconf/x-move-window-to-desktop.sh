#/bin/bash
# usage: ./x-move-window-to-desktop.sh gmail wmaker_desktop_number
echo $1
xdotool  search  $1
for w in $(xdotool  search  "$1" )
 do 
   echo $w
   xdotool set_desktop_for_window  $w  $(expr $2 - 1)
done
