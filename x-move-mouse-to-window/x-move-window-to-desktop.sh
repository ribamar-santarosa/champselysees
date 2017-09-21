#/bin/bash
# usage: ./x-move-window-to-desktop.sh gmail wmaker_desktop_number
for w in $(xdotool  search  "$1" )
 do xdotool set_desktop_for_window  $w  $(expr $2 - 1)
done
