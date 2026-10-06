#!/bin/sh

THEME="$HOME/.config/rofi/theme.rasi"

json=$(dunstctl history 2>/dev/null)

[ -n "$json" ] || exit 0

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT HUP INT TERM

printf '%s\n' "$json" |
    jq -r '
        .data[] |
        .[] |
        [
            .id.data,
            .appname.data,
            .summary.data,
            .body.data
        ] |
        @tsv
    ' |
    while IFS="$(printf '\t')" read -r id app summary body
    do
        body=$(printf '%s' "$body" |
            sed 's/<[^>]*>//g' |
            tr '\r\n\t' '   ' |
            cut -c 1-90)

        summary=$(printf '%s' "$summary" |
            sed 's/<[^>]*>//g' |
            tr '\r\n\t' ' ' |
            cut -c 1-70)

        app=$(printf '%s' "$app" |
            tr '\r\n\t' ' ' |
            cut -c 1-30)

        printf '%s\t%s: %s — %s\n' \
            "$id" "$app" "$summary" "$body"
    done > "$tmp"

[ -s "$tmp" ] || exit 0

display=$(cut -f2- "$tmp" |
    rofi -dmenu \
        -i \
        -p "NOTIFY" \
        -theme "$THEME")

[ -n "$display" ] || exit 0

id=$(awk -F '\t' -v value="$display" '
    $2 == value {
        print $1
        exit
    }
' "$tmp")

[ -n "$id" ] || exit 0

dunstctl history-pop "$id"
