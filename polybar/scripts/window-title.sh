#!/bin/sh

wid=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null |
    awk '{print $5}')

[ -z "$wid" ] && exit 0
[ "$wid" = "0x0" ] && exit 0

title=$(xprop -id "$wid" _NET_WM_NAME 2>/dev/null |
    sed -n 's/^_NET_WM_NAME(UTF8_STRING) = "\(.*\)"$/\1/p')

if [ -z "$title" ]; then
    title=$(xprop -id "$wid" WM_NAME 2>/dev/null |
        sed -n 's/^WM_NAME(STRING) = "\(.*\)"$/\1/p')
fi

[ -z "$title" ] && title="Desktop"

printf '%s\n' "$title"
