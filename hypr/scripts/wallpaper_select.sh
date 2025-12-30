#!/usr/bin/env bash

wallpaperDir="$HOME/nix/wallpapers" #move this?
scriptsDir="$HOME/.config/hypr/scripts"

# variables
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
# swww transition config
FPS=240
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

#wallust run $RANDOM_PIC


# Define the path to the swww cache directory
cache_dir="$HOME/.cache/swww/"

# Get a list of monitor outputs
monitor_outputs=($(ls "$cache_dir"))

# Initialize a flag to determine if the ln command was executed
ln_success=false

# Get current focused monitor
current_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
echo $current_monitor
# Construct the full path to the cache file
cache_file="$cache_dir$current_monitor"
echo $cache_file
# Check if the cache file exists for the current monitor output
if [ -f "$cache_file" ]; then
  # Get the wallpaper path from the cache file
  wallpaper_path=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)
  echo $wallpaper_path
  # symlink the wallpaper to the location Rofi can access
  if ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"; then
    ln_success=true # Set the flag to true upon successful execution
  fi
  # copy the wallpaper for wallpaper effects
  cp -r "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
fi

# Check the flag before executing further commands
if [ "$ln_success" = true ]; then
  # execute wallust
  echo 'about to execute wallust'
  # execute wallust skipping tty and terminal changes
  wallust run "$wallpaper_path" -s &

fi

sleep 0.5
"$scriptsDir/refresh.sh"