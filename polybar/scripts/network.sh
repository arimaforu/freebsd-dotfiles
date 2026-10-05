#!/bin/sh

iface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')

[ -z "$iface" ] && exit 0

read_stats() {
    netstat -ibn -I "$iface" 2>/dev/null | awk '
        NR == 1 {
            for (i = 1; i <= NF; i++) {
                if ($i == "Ibytes") ib = i
                if ($i == "Obytes") ob = i
            }
            next
        }
        $1 == iface && ib && ob {
            print $ib, $ob
            exit
        }
    ' iface="$iface"
}

set -- $(read_stats)

rx=${1:-0}
tx=${2:-0}

state="/tmp/polybar-net-${USER}.state"
now=$(date +%s)

if [ -f "$state" ]; then
    read old_rx old_tx old_time < "$state"
else
    old_rx=$rx
    old_tx=$tx
    old_time=$now
fi

elapsed=$((now - old_time))
[ "$elapsed" -le 0 ] && elapsed=1

down=$(( (rx - old_rx) / elapsed ))
up=$(( (tx - old_tx) / elapsed ))

[ "$down" -lt 0 ] && down=0
[ "$up" -lt 0 ] && up=0

printf '%s %s %s\n' "$rx" "$tx" "$now" > "$state"

format_speed() {
    awk -v b="$1" 'BEGIN {
        if (b < 1024)
            printf "%.0f B/s", b
        else if (b < 1048576)
            printf "%.1f KB/s", b / 1024
        else
            printf "%.1f MB/s", b / 1048576
    }'
}

printf '↓ %s  ↑ %s\n' "$(format_speed "$down")" "$(format_speed "$up")"
