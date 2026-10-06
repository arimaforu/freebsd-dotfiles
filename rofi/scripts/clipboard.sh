#!/bin/sh

THEME="$HOME/.config/rofi/theme.rasi"
HISTORY_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/freebsd-dotfiles/clipboard-history"

[ -f "$HISTORY_FILE" ] || exit 0

display=$(mktemp)
trap 'rm -f "$display"' EXIT HUP INT TERM

i=1

while IFS= read -r encoded; do
    [ -n "$encoded" ] || continue

    text=$(printf '%s' "$encoded" | base64 -d 2>/dev/null) || continue
    preview=$(printf '%s' "$text" | tr '\n\t' '  ' | cut -c 1-100)

    printf '%03d  %s\n' "$i" "$preview" >> "$display"
    i=$((i + 1))
done < "$HISTORY_FILE"

[ -s "$display" ] || exit 0

choice=$(rofi -dmenu -i -p "CLIP" -theme "$THEME" < "$display")
[ -n "$choice" ] || exit 0

index=$(printf '%s\n' "$choice" | cut -c 1-3 | tr -d ' ')
[ -n "$index" ] || exit 0

encoded=$(sed -n "${index}p" "$HISTORY_FILE")
[ -n "$encoded" ] || exit 0

printf '%s' "$encoded" | base64 -d 2>/dev/null | xclip -selection clipboard
