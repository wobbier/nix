#!/usr/bin/env bash

wallpaperDir="$HOME/nix/wallpapers" #move this?
scriptsDir="$HOME/.config/hypr/scripts"

# variables
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
# swww transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

mapfile -d '' PICS < <(find "${wallpaperDir}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"

swww query || swww-daemon --format xrgb

swww img -o "$focused_monitor" "$RANDOM_PIC" $SWWW_PARAMS
echo "$focused_monitor" "\"$RANDOM_PIC\"" $SWWW_PARAMS
sleep 0.5

wallust run $RANDOM_PIC

sleep 0.5
"$scriptsDir/refresh.sh"