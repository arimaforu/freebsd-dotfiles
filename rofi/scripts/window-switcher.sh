#!/bin/sh

theme="$HOME/.config/rofi/theme.rasi"

choice=$(wmctrl -l |
    sed 's/^[^ ]* [^ ]* [^ ]* //' |
    rofi -dmenu \
        -i \
        -p "WINDOW" \
        -theme "$theme")

[ -z "$choice" ] && exit 0

wmctrl -l |
while read -r id desktop host title
do
    [ "$title" = "$choice" ] && {
        wmctrl -ia "$id"
        exit 0
    }
done
