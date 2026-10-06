#!/bin/sh

SCRIPT_DIR="$HOME/.config/bspwm/scripts"
LOG="$HOME/.cache/freebsd-dotfiles/watchdog.log"

mkdir -p "$(dirname "$LOG")"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG"
}

while :; do

    if ! pgrep -x sxhkd >/dev/null 2>&1; then
        log "sxhkd died, restarting"
        sxhkd &
    fi

    if ! pgrep -x dunst >/dev/null 2>&1; then
        log "dunst died, restarting"
        dunst &
    fi

    if ! pgrep -x picom >/dev/null 2>&1; then
        log "picom died, restarting"
        picom --config /dev/null -b --backend=xrender \
            --shadow \
            --shadow-radius=8 \
            --shadow-offset-x=-4 \
            --shadow-offset-y=-4 \
            --inactive-opacity=0.92 \
            --active-opacity=1.0
    fi

    if ! pgrep -x polybar >/dev/null 2>&1; then
        log "polybar died, restarting"
        polybar y2k &
    fi

    if command -v xclip >/dev/null 2>&1 &&
       ! pgrep -f '[c]lipboard-daemon.sh' >/dev/null 2>&1; then
        log "clipboard daemon died, restarting"
        "$SCRIPT_DIR/clipboard-daemon.sh" &
    fi

    sleep 5
done
