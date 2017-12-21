#!/bin/bash

while true
do

stime=$( [[ ! -z "$1" ]] && echo "$1"  || echo 30 )
speak_limit=$( [[ ! -z "$2" ]] && echo "$2"  || echo 12 )
suspend_limit=$( [[ ! -z "$3" ]] && echo "$3"  || echo 10 )
hibernate_limit=$( [[ ! -z "$4" ]] && echo "$4"  || echo 5 )
plugged="$( acpi -a | grep on-line  )"

battery=$(acpi   | sed "s/.* \([^\s]*\)%.*/\1/")
if [ -z "$battery" ] ; then export msg="${msg}; urgent, provide script maintenance" ; fi
if [ "$battery" -lt "$speak_limit" ] ; then export msg="${msg}; battery low: ${battery}%" ; fi
if [ "$battery" -lt "$suspend_limit" ] ; then [[ -z "$plugged" ]] &&  sudo pm-suspend ; fi
if [ "$battery" -lt "$hibernate_limit" ] ; then [[ -z "$plugged" ]] &&  sudo pm-hibernate ; fi
echo $(date) "[plugged=$plugged][battery=$battery]:$msg" >> /tmp/acpi-msg
if [ ! -z "$msg" ]  ; then [[ -z "$plugged" ]] &&  espeak "$msg" ; fi
unset msg
unset battery
unset plugged
sleep $stime
done
