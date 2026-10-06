#!/bin/sh

HISTORY_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/freebsd-dotfiles"
HISTORY_FILE="$HISTORY_DIR/clipboard-history"

MAX_ITEMS=50
MAX_BYTES=1048576

mkdir -p "$HISTORY_DIR"
touch "$HISTORY_FILE"
chmod 600 "$HISTORY_FILE"

umask 077

last=""

format_size() {
    awk -v bytes="$1" 'BEGIN {
        if (bytes < 1024)
            printf "%d B", bytes
        else if (bytes < 1048576)
            printf "%.1f KB", bytes / 1024
        else
            printf "%.2f MB", bytes / 1048576
    }'
}

while :; do
    current=$(xclip -selection clipboard -o 2>/dev/null)

    if [ $? -ne 0 ]; then
        sleep 0.5
        continue
    fi

    [ -n "$current" ] || {
        sleep 0.5
        continue
    }

    encoded=$(printf '%s' "$current" | base64 | tr -d '\n')

    # Clipboard hasn't changed.
    if [ "$encoded" = "$last" ]; then
        sleep 0.5
        continue
    fi

    last="$encoded"

    size=$(printf '%s' "$current" | wc -c | tr -d ' ')

    # Too large: don't save it, but tell the user why.
    if [ "$size" -gt "$MAX_BYTES" ]; then
        notify-send \
            -u normal \
            -t 5000 \
            "CLIPBOARD" \
            "Entry too large: $(format_size "$size") (limit 1.00 MB)"
        sleep 0.5
        continue
    fi

    # Don't store duplicates.
    if grep -Fqx "$encoded" "$HISTORY_FILE" 2>/dev/null; then
        sleep 0.5
        continue
    fi

    {
        printf '%s\n' "$encoded"
        cat "$HISTORY_FILE"
    } | awk -v max="$MAX_ITEMS" 'NR <= max' > "$HISTORY_FILE.tmp"

    if [ $? -eq 0 ]; then
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
        chmod 600 "$HISTORY_FILE"
    else
        rm -f "$HISTORY_FILE.tmp"
        notify-send \
            -u critical \
            -t 5000 \
            "CLIPBOARD" \
            "Failed to save clipboard history"
    fi

    sleep 0.5
done
