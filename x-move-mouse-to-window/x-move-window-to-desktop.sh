#/bin/bash
xdotool set_desktop_for_window  $(xdotool  search  "$1" | head -1 ) 10485869 3
