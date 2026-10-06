#!/bin/sh

HEADPHONE_VOLUME=40
SPEAKER_VOLUME=70
POLL_INTERVAL=1

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/freebsd-dotfiles-audio.state"

set_volume() {
    mixer "vol=$1%" >/dev/null 2>&1
}

headphone_pins() {
    dmesg -a 2>/dev/null | awk '
        /^hdaa[0-9]+:/ {
            dev=$1
            sub(/:$/, "", dev)
        }

        /Headphones[[:space:]]+Jack/ {
            line=$0
            sub(/^hdaa[0-9]+:[[:space:]]*/, "", line)
            split(line, f, /[[:space:]]+/)

            if (f[1] ~ /^[0-9]+$/)
                print dev ":" f[1]
        }
    ' | sort -u
}

get_headphone_state() {
    pins=$(headphone_pins)

    [ -n "$pins" ] || {
        printf '%s\n' "unknown"
        return
    }

    dmesg -a 2>/dev/null | awk -v pins="$pins" '
        BEGIN {
            count=split(pins, p, /\n/)
            for (i=1; i<=count; i++)
                wanted[p[i]]=1
        }

        /^hdaa[0-9]+: Pin sense:/ {
            dev=$1
            sub(/:$/, "", dev)

            if (match($0, /nid=[0-9]+/)) {
                nid=substr($0, RSTART+4, RLENGTH-4)
                key=dev ":" nid

                if (key in wanted) {
                    if ($0 ~ /\(connected\)/)
                        state[key]="connected"
                    else if ($0 ~ /\(disconnected\)/)
                        state[key]="disconnected"
                }
            }
        }

        END {
            for (key in state) {
                if (state[key] == "connected") {
                    print "connected"
                    exit
                }
            }

            for (key in state) {
                if (state[key] == "disconnected") {
                    print "disconnected"
                    exit
                }
            }

            print "unknown"
        }
    '
}

apply_state() {
    case "$1" in
        connected)
            set_volume "$HEADPHONE_VOLUME"
            ;;
        disconnected)
            set_volume "$SPEAKER_VOLUME"
            ;;
    esac
}

while :; do
    state=$(get_headphone_state)

    case "$state" in
        connected|disconnected)
            previous=$(cat "$STATE_FILE" 2>/dev/null)

            if [ "$state" != "$previous" ]; then
                apply_state "$state"
                printf '%s\n' "$state" > "$STATE_FILE"
                chmod 600 "$STATE_FILE"
            fi
            ;;
    esac

    sleep "$POLL_INTERVAL"
done
