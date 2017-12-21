#/bin/bash
pushd /home/ribamar/to-merge/recordings ; ( audacity &) ; popd
chromium www.gmail.com &
sleep 1
chromium app.simplenote.com &
sleep 1
chromium translate.google.com &
sleep 3
chromium   --new-window  www.messenger.com &
sleep 1
chromium www.facebook.com &
sleep 1
chromium  "www.amsterdamstun.com/giglist.php"    &
sleep 1
chromium "https://radar.squat.net/en/events/country/NL" &

chromium --new-window   "https://www.weerplaza.nl/regenradar/amsterdam/5575/" &
sleep 1
chromium "https://www.buienradar.nl/weer/amsterdam/nl/2759794/3uurs" &
sleep 1
chromium "https://www.timeanddate.com/weather/netherlands/amsterdam" &
sleep 1
chromium "https://www.timeanddate.com/weather/netherlands/amsterdam/historic" &
sleep 1

# firefox -new-window   "https://www.weerplaza.nl/regenradar/amsterdam/5575/"
# firefox "https://www.buienradar.nl/weer/amsterdam/nl/2759794/3uurs"
# firefox "https://www.timeanddate.com/weather/netherlands/amsterdam"
# firefox "https://www.timeanddate.com/weather/netherlands/amsterdam/historic"

chromium --new-window   "https://www.office.com/"   &
sleep 1
chromium "https://www.office.com/"   &
sleep 1
chromium app.simplenote.com &
sleep 1
chromium app.simplenote.com &
sleep 1
chromium app.simplenote.com &
sleep 1
chromium "https://nedsenseloft.atlassian.net " &
sleep 1
chromium "https://nedsenseloft.atlassian.net/wiki/spaces/ROOOMY"  &
sleep 1
chromium "https://bitbucket.org/NedSense/"  &
sleep 1
chromium "rooomy.slack.com"  &

pcmanfm &
pavucontrol &
skypeforlinux &
pushd /home/ribamar/to-merge/wt/virt/ ; (  ./run_img.sh & ) ; popd
./acpi.sh &
xscreensaver -nosplash  &
xset b off
setxkbmap -model pc105 -layout us -variant alt-intl # this worked for revolvedeb910, but of course the

gnome-terminal & 
gnome-terminal & 
gnome-terminal & 
gnome-terminal & 

echo end
