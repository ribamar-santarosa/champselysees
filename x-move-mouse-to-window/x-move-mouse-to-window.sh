#/bin/bash
xdotool mousemove --window $(xdotool  search  "$1" | head -1 )   0${2} 0${3}
