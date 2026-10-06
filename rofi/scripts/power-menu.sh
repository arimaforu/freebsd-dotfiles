#!/bin/sh

choice=$(printf '%s\n' \
    "⏻  Shutdown" \
    "↻  Reboot" \
    "⇥  Logout" |
    rofi -dmenu -i -p "Power" \
        -theme "$HOME/.config/rofi/theme.rasi")

case "$choice" in
    *Shutdown)
        doas shutdown -p now
        ;;
    *Reboot)
        doas reboot
        ;;
    *Logout)
        bspc quit
        ;;
esac
