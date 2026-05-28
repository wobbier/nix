#!/usr/bin/env bash

OUT_DIR="$HOME/Videos/Recordings"
LOG_FILE="/tmp/wf-recorder-region.log"

mkdir -p "$OUT_DIR"

# If wf-recorder is currently running, stop it cleanly.
if pgrep -u "$USER" -x wf-recorder >/dev/null; then
    pkill -INT -u "$USER" -x wf-recorder
    notify-send "Screen recording" "Stopped recording"
    exit 0
fi

notify-send "Screen recording" "Select an area to record"

GEOMETRY="$(slurp -b 11111188 -c ff5555ff -s ff555544 -w 3)"

if [[ -z "$GEOMETRY" ]]; then
    notify-send "Screen recording" "Selection cancelled"
    exit 1
fi

OUT_FILE="$OUT_DIR/recording-$(date +'%Y-%m-%d_%H-%M-%S').mkv"

rm -f "$LOG_FILE"

wf-recorder \
    -g "$GEOMETRY" \
    -f "$OUT_FILE" \
    >"$LOG_FILE" 2>&1 &

sleep 0.5

if ! pgrep -u "$USER" -x wf-recorder >/dev/null; then
    notify-send "Screen recording failed" "Check /tmp/wf-recorder-region.log"
    exit 1
fi

notify-send "Screen recording" "Recording started"