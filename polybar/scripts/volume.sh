#!/bin/sh

while :; do
    data=$(mixer -o vol.volume vol.mute 2>/dev/null)

    volume=$(printf '%s\n' "$data" |
        sed -n 's/.*vol.volume=\([0-9.]*\).*/\1/p')

    mute=$(printf '%s\n' "$data" |
        sed -n 's/.*vol.mute=\([^ ]*\).*/\1/p')

    if [ "$mute" = "on" ]; then
        printf '  MUTE\n'
    else
        percent=$(awk -v v="${volume:-0}" 'BEGIN {printf "%.0f", v * 100}')

        if [ "$percent" -le 0 ]; then
            icon=""
        elif [ "$percent" -le 50 ]; then
            icon=""
        else
            icon=""
        fi

        printf '%s  %s%%\n' "$icon" "$percent"
    fi

    sleep 0.1
done
