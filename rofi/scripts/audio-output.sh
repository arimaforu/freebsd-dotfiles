#!/bin/sh

THEME="$HOME/.config/rofi/theme.rasi"

current=$(sysctl -n hw.snd.default_unit 2>/dev/null || echo 0)

devices=$(
    awk -v current="pcm$current" '
    /^pcm[0-9]+:/ {
        id=$1
        sub(/:$/, "", id)

        desc=$0
        sub(/^[^:]+:[[:space:]]*/, "", desc)
        gsub(/[[:space:]]+default[[:space:]]*$/, "", desc)

        if (id == current)
            prefix="● "
        else
            prefix="  "

        printf "%s%s  %s\n", prefix, id, desc
    }
    ' /dev/sndstat 2>/dev/null
)

[ -n "$devices" ] || {
    notify-send -u critical "AUDIO" "No audio devices found"
    exit 1
}

choice=$(printf '%s\n' "$devices" |
    rofi -dmenu \
        -i \
        -p "AUDIO" \
        -theme "$THEME")

[ -n "$choice" ] || exit 0

device=$(printf '%s\n' "$choice" |
    awk '{for (i=1; i<=NF; i++) if ($i ~ /^pcm[0-9]+$/) {print $i; exit}}')

[ -n "$device" ] || exit 1

unit=${device#pcm}

if doas sysctl "hw.snd.default_unit=$unit" >/dev/null 2>&1; then
    notify-send "AUDIO" "Output switched to $device"
else
    notify-send -u critical "AUDIO" "Failed to switch output"
    exit 1
fi
