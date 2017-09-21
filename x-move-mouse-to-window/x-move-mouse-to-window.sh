#/bin/bash
# xdotool search $1 windowfocus # not working
# xdotool search $1 windowmove 1000 0 # works for window moving
xdotool mousemove --window $(xdotool  search  "$1" | head -1 )   0${2} 0${3}
