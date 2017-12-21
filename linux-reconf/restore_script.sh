./x-move-window-to-desktop.sh "Audacity" 2
./x-move-window-to-desktop.sh "ribamar@revolvedeb910" 2
./x-move-window-to-desktop.sh "Mozilla Firefox" 4
./x-move-window-to-desktop.sh "Regenradar Amsterdam - actuele buien radar | Weerplaza.nl - Mozilla Firefox" 6
./x-move-window-to-desktop.sh "Volume Control" 2
./x-move-window-to-desktop.sh "Skype" 7
./x-move-window-to-desktop.sh "QEMU" 5

xdotool search "QEMU" | while read l ; do xdotool   windowsize  $l 800 600  ; done
xdotool search "QEMU" | while read l ; do xdotool   windowmove  $l 200 100  ; done

# chromium cluster
cn=1
./x-move-window-to-desktop.sh "ribamar@gmail.com - Gmail - Chromium" $cn
./x-move-window-to-desktop.sh "Simplenote - Chromium" $cn
./x-move-window-to-desktop.sh "Google Translate - Chromium" $cn
cn=3
./x-move-window-to-desktop.sh "Messenger - Chromium" $cn
./x-move-window-to-desktop.sh "Facebook - Chromium" $cn
./x-move-window-to-desktop.sh "radar.squat.net - Chromium" $cn
./x-move-window-to-desktop.sh "Gig List - Chromium" $cn
cn=6
./x-move-window-to-desktop.sh "Regenradar Amsterdam - actuele buien radar | Weerplaza.nl - Chromium" $cn
./x-move-window-to-desktop.sh "Buienradar.nl" $cn
./x-move-window-to-desktop.sh "Weather for Amsterdam" $cn
./x-move-window-to-desktop.sh "Past Weather in Amsterdam" $cn
cn=8
./x-move-window-to-desktop.sh "Microsoft Office" $cn
