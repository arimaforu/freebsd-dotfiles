#!/bin/sh

iface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')

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

if [ -z "$iface" ]; then
    printf '  OFFLINE'
    exit 0
fi

info=$(ifconfig "$iface" 2>/dev/null)
status=$(printf '%s\n' "$info" | awk -F': ' '/^[[:space:]]*status:/{print $2; exit}')

case "$iface" in
    wlan*|ath*|iwn*|iwm*|rtw*|ral*|urtw*)
        if [ "$status" = "associated" ]; then
            ssid=$(printf '%s\n' "$info" |
                awk '
                    /^[[:space:]]*ssid / {
                        sub(/^[[:space:]]*ssid /, "")
                        sub(/ channel .*/, "")
                        print
                        exit
                    }')
            [ -n "$ssid" ] || ssid="Wi-Fi"
            connection="  $ssid"
        else
            connection="  Wi-Fi"
        fi
        ;;
    *)
        if [ "$status" = "active" ]; then
            connection="  Ethernet"
        else
            connection="  Ethernet"
        fi
        ;;
esac

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
    read old_iface old_rx old_tx old_time < "$state"
else
    old_iface=""
    old_rx=$rx
    old_tx=$tx
    old_time=$now
fi

if [ "$old_iface" != "$iface" ]; then
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

printf '%s %s %s %s\n' "$iface" "$rx" "$tx" "$now" > "$state"

printf '%s  ↓ %s  ↑ %s\n' \
    "$connection" \
    "$(format_speed "$down")" \
    "$(format_speed "$up")"
