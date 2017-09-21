#!/bin/bash

battery=$(acpi   | sed "s/.* \([^\s]*\)%.*/\1/")
if [ -z "$battery" ] ; then export msg="${msg}; urgent, provide script maintenance" ; fi
if [ "$battery" -lt 20 ] ; then export msg="${msg}; battery low: ${battery}%" ; fi
if [ "$battery" -lt 10 ] ; then sudo pm-suspend ; fi
if [ "$battery" -lt 5 ] ; then sudo pm-hibernate ; fi
echo $(date) "[battery=$battery]:$msg" | tee -a /tmp/acpi-msg
if [ ! -z "$msg" ]  ; then espeak "$msg" ; fi
unset msg
unset battery
