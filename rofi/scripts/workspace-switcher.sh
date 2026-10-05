#!/bin/sh

theme="$HOME/.config/rofi/theme.rasi"

choice=$(printf '%s\n' \
    "1  Workspace 1" \
    "2  Workspace 2" \
    "3  Workspace 3" \
    "4  Workspace 4" \
    "5  Workspace 5" \
    "6  Workspace 6" \
    "7  Workspace 7" \
    "8  Workspace 8" \
    "9  Workspace 9" |
    rofi -dmenu \
        -i \
        -p "WORKSPACE" \
        -theme "$theme")

[ -z "$choice" ] && exit 0

desktop=$(printf '%s\n' "$choice" | cut -d' ' -f1)

bspc desktop -f "^$desktop"
