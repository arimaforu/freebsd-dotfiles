#!/bin/sh

HISTORY_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/freebsd-dotfiles"
HISTORY_FILE="$HISTORY_DIR/clipboard-history"
MAX_ITEMS=50

mkdir -p "$HISTORY_DIR"
touch "$HISTORY_FILE"

last=""

while :; do
    current=$(xclip -selection clipboard -o 2>/dev/null) || {
        sleep 0.5
        continue
    }

    [ -n "$current" ] || {
        sleep 0.5
        continue
    }

    encoded=$(printf '%s' "$current" | base64 | tr -d '\n')

    if [ "$encoded" = "$last" ]; then
        sleep 0.5
        continue
    fi

    last="$encoded"

    if grep -Fqx "$encoded" "$HISTORY_FILE" 2>/dev/null; then
        sleep 0.5
        continue
    fi

    {
        printf '%s\n' "$encoded"
        cat "$HISTORY_FILE"
    } | awk -v max="$MAX_ITEMS" 'NR <= max' > "$HISTORY_FILE.tmp" &&
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

    sleep 0.5
done
