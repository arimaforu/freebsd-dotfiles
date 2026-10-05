#!/bin/sh

theme="$HOME/.config/rofi/theme.rasi"

file=$(locate -i "$HOME" 2>/dev/null |
    grep "^$HOME/" |
    grep -v '/\.cache/' |
    grep -v '/\.local/share/Trash/' |
    rofi -dmenu \
        -i \
        -p "FILE" \
        -theme "$theme")

[ -z "$file" ] && exit 0

if [ -d "$file" ]; then
    thunar "$file" &
else
    xdg-open "$file" &
fi
