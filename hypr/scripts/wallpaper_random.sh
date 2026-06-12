#!/usr/bin/env bash
set -u

wallpaperDir="$HOME/nix/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

mapfile -d '' PICS < <(
  find "$wallpaperDir" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.gif" \
  \) -print0
)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"

"$scriptsDir/wallpaper_select.sh" "$RANDOM_PIC"
