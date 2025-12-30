#!/usr/bin/env bash

_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

sleep 0.3
waybar &

# kitty @ set-colors --all --configured ~/.config/kitty/colors-kitty.conf

# relaunch notification daemon

exit 0