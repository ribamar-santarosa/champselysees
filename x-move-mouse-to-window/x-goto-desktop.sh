#/bin/bash
# --relative as option
# note: desktop 3 in X is desktop 4 for windowmaker
# xdotool set_desktop  $2 $(expr $1 - 1) # note: relative given -- no expr should take place
xdotool set_desktop $(expr $1 - 1)
