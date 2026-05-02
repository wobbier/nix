#!/usr/bin/env bash
set -u

wallpaperDir="$HOME/nix/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

FPS=240
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [ $# -ge 1 ] && [ -f "$1" ]; then
  RANDOM_PIC="$1"
else
  mapfile -d '' PICS < <(
    find "$wallpaperDir" -type f \( \
      -iname "*.jpg" -o \
      -iname "*.jpeg" -o \
      -iname "*.png" -o \
      -iname "*.gif" \
    \) -print0
  )
  RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
fi

awww query >/dev/null 2>&1 || awww-daemon --format xrgb
awww img -o "$focused_monitor" "$RANDOM_PIC" $SWWW_PARAMS

echo "monitor: $focused_monitor"
echo "wallpaper: $RANDOM_PIC"

sleep 0.5

ln_success=false

if [ -n "$RANDOM_PIC" ]; then
  if ln -sf "$RANDOM_PIC" "$HOME/.config/rofi/.current_wallpaper"; then
    ln_success=true
  fi

  cp -f "$RANDOM_PIC" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
fi

if [ "$ln_success" = true ]; then
  echo "about to execute wallust"

  command -v wallust
  wallust run "$RANDOM_PIC" -s
fi

sleep 0.5
"$scriptsDir/refresh.sh"