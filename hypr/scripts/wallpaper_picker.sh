#!/usr/bin/env bash
set -u

wallpaperDir="$HOME/nix/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

selected=$(find "$wallpaperDir" -maxdepth 1 -type f \
  -iname "*.jpg" -o -type f -iname "*.jpeg" \
  -o -type f -iname "*.png" -o -type f -iname "*.gif" \
  | sort \
  | while read -r f; do
      printf '%s\0icon\x1f%s\n' "$(basename "$f")" "$f"
    done \
  | rofi -dmenu \
      -show-icons \
      -p "Wallpaper" \
      -i \
      -theme-str 'element-icon { size: 8em; }' \
      -theme-str 'listview { columns: 4; lines: 3; }')

[ -z "$selected" ] && exit 0

selected_path=$(find "$wallpaperDir" -maxdepth 1 -type f -name "$selected" | head -n 1)

[ -z "$selected_path" ] && exit 1

"$scriptsDir/wallpaper_select.sh" "$selected_path"
