#!/bin/sh

USER_NAME="user"

EVENT="$1"
DEVICE="$2"

PID="$(pgrep -u "$USER_NAME" -x bspwm | head -n 1)"

[ -n "$PID" ] || exit 0

ENV="$(procstat -e "$PID" 2>/dev/null)"

DISPLAY_VALUE="$(printf '%s\n' "$ENV" |
    sed -n 's/.*DISPLAY=\([^ ]*\).*/\1/p' |
    head -n 1)"

DBUS_VALUE="$(printf '%s\n' "$ENV" |
    sed -n 's/.*DBUS_SESSION_BUS_ADDRESS=\([^ ]*\).*/\1/p' |
    head -n 1)"

[ -n "$DISPLAY_VALUE" ] || DISPLAY_VALUE=":0"

case "$EVENT" in
    ATTACH)
        TITLE="Device connected"
        ;;
    DETACH)
        TITLE="Device disconnected"
        ;;
    *)
        exit 0
        ;;
esac

NAME="$DEVICE"

if [ -n "$DEVICE" ] && command -v usbconfig >/dev/null 2>&1; then
    PRODUCT="$(usbconfig -d "$DEVICE" dump_device_desc 2>/dev/null |
        sed -n 's/.*product=\(.*\)/\1/p' |
        head -n 1)"

    [ -n "$PRODUCT" ] && NAME="$PRODUCT"
fi

if [ -n "$DBUS_VALUE" ]; then
    su -m "$USER_NAME" -c \
        "DISPLAY='$DISPLAY_VALUE' DBUS_SESSION_BUS_ADDRESS='$DBUS_VALUE' \
        dunstify -a 'devd' -u normal -t 4000 '$TITLE' '$NAME'"
fi
