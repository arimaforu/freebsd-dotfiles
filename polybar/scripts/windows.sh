#!/bin/sh

active=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $5}')

wmctrl -l -x 2>/dev/null | while read -r id desktop host title
do
    [ -z "$id" ] && continue
    [ -z "$title" ] && continue

    title=$(printf '%s' "$title" | cut -c1-24)

    if [ "$id" = "$active" ]; then
        printf '%%{A1:wmctrl -ia %s:}%%{F#00ffcc}[ %s ]%%{F-}%%{A} ' "$id" "$title"
    else
        printf '%%{A1:wmctrl -ia %s:}%%{F#707985}%s%%{F-}%%{A} ' "$id" "$title"
    fi
done
