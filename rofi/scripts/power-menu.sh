#!/bin/sh

choice=$(printf "  Lock\n󰐥  Shutdown\n󰜉  Reboot\n󰍃  Logout" | rofi -dmenu -i -p "Power" \
    -theme ~/.config/rofi/theme.rasi)

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
