#!/bin/sh

OUTPUT=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')
[ -n "$OUTPUT" ] || exit 1

MODE=$(xrandr --query 2>/dev/null | awk '
/ connected/ {found=1; next}
found && /^[[:space:]]*[0-9]+x[0-9]+/ && /\*/ {
    print $1
    exit
}')

[ -n "$MODE" ] || exit 1

RATES=$(xrandr --query 2>/dev/null |
    awk -v mode="$MODE" '
    $1 == mode {
        for (i = 2; i <= NF; i++) {
            gsub(/[+*]/, "", $i)
            if ($i ~ /^[0-9]+(\.[0-9]+)?$/)
                print $i
        }
    }' |
    sort -n -u)

[ -n "$RATES" ] || exit 1

HIGHEST=$(printf '%s\n' "$RATES" | sort -n | tail -n 1)

OPTIONS="Авто ($HIGHEST Гц)"
while read -r rate; do
    OPTIONS="$OPTIONS
$rate Гц"
done <<EOF2
$RATES
EOF2

CHOICE=$(printf '%s\n' "$OPTIONS" |
    rofi -dmenu -i -p "Частота" \
    -theme "$HOME/.config/rofi/theme.rasi")

case "$CHOICE" in
    Авто*)
        xrandr --output "$OUTPUT" --mode "$MODE" --rate "$HIGHEST" 2>/dev/null
        ;;
    *)
        RATE=$(printf '%s' "$CHOICE" | awk '{print $1}')
        [ -n "$RATE" ] || exit 0
        xrandr --output "$OUTPUT" --mode "$MODE" --rate "$RATE" 2>/dev/null
        ;;
esac
