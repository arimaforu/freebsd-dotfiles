#!/bin/sh

data=$(acpiconf -i 0 2>/dev/null)

[ -n "$data" ] || exit 0

state=$(printf '%s\n' "$data" |
    awk -F': *' '/^State:/ {print $2; exit}')

percent=$(printf '%s\n' "$data" |
    awk -F': *' '/^Remaining capacity:/ {
        gsub(/%.*/, "", $2)
        print $2
        exit
    }')

case "$percent" in
    ''|*[!0-9]*)
        exit 0
        ;;
esac

if [ "$percent" -ge 80 ]; then
    icon=""
elif [ "$percent" -ge 60 ]; then
    icon=""
elif [ "$percent" -ge 40 ]; then
    icon=""
elif [ "$percent" -ge 20 ]; then
    icon=""
else
    icon=""
fi

case "$state" in
    charging*)
        icon=""
        ;;
    critical*)
        icon=""
        ;;
esac

printf '%s  %s%%\n' "$icon" "$percent"
