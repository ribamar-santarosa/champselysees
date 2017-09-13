#!/bin/bash

battery=$(acpi   | sed "s/.* \([^\s]*\)%.*/\1/")
if [ -z "$battery" ] ; then export msg="${msg}; urgent, provide script maintenance" ; fi
if [ "$battery" -lt 12 ] ; then export msg="${msg}; battery low: ${battery}%" ; fi
echo $(date) "[battery=$battery]:$msg" | tee -a /tmp/acpi-msg
if [ ! -z "$msg" ]  ; then espeak "$msg" ; fi
unset msg
unset battery
