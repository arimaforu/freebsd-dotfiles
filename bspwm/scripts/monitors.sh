#!/bin/sh

set -- $(bspc query -M --names)

count=$#

[ "$count" -gt 0 ] || exit 1

# Remove old desktop assignments from all monitors.
for monitor in "$@"; do
    bspc monitor "$monitor" -d >/dev/null 2>&1
done

desktop=1
index=1

base=$((9 / count))
remainder=$((9 % count))

for monitor in "$@"; do
    desktops=""
    amount="$base"

    if [ "$index" -le "$remainder" ]; then
        amount=$((amount + 1))
    fi

    i=0

    while [ "$i" -lt "$amount" ]; do
        desktops="$desktops $desktop"
        desktop=$((desktop + 1))
        i=$((i + 1))
    done

    bspc monitor "$monitor" -d $desktops

    index=$((index + 1))
done

# Focus the first monitor.
bspc monitor -f "$(bspc query -M --names | head -n 1)"
