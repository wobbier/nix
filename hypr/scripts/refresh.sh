#!/usr/bin/env bash

_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

#ags quit # unneeded?

sleep 0.3
waybar &

# relaunch notification daemon

exit 0