#!/bin/sh

THEME="$HOME/.config/rofi/theme.rasi"

# Find first connected output.
output=$(xrandr --query 2>/dev/null |
    awk '/ connected/ {
        print $1
        exit
    }')

[ -n "$output" ] || {
    notify-send -u critical "DISPLAY" "Display output not found"
    exit 1
}

# Get all suitable 16:9 modes.
modes=$(xrandr --query 2>/dev/null |
    awk -v out="$output" '
        $1 == out && $2 == "connected" {
            found=1
            next
        }

        found && /^[[:space:]]+[0-9]+x[0-9]+/ {
            mode=$1
            sub(/[+*].*$/, "", mode)

            split(mode, a, "x")
            w=a[1]
            h=a[2]

            if (w < 800 || h < 600)
                next

            if (w > 3840 || h > 2160)
                next

            ratio=w / h

            if (ratio > 1.75 && ratio < 1.80)
                print mode
        }

        found && /^[^[:space:]]/ {
            exit
        }
    ' |
    sort -t x -k1,1nr -k2,2nr |
    awk '!seen[$0]++'
)

[ -n "$modes" ] || {
    notify-send -u critical "DISPLAY" "No suitable resolutions found"
    exit 1
}

# Find the current mode and preferred mode.
current=$(xrandr --query 2>/dev/null |
    awk -v out="$output" '
        $1 == out && $2 == "connected" {
            found=1
            next
        }

        found && /^[[:space:]]+[0-9]+x[0-9]+/ && /\*/ {
            mode=$1
            sub(/[+*].*$/, "", mode)
            print mode
            exit
        }

        found && /^[^[:space:]]/ {
            exit
        }
    ')

preferred=$(xrandr --query 2>/dev/null |
    awk -v out="$output" '
        $1 == out && $2 == "connected" {
            found=1
            next
        }

        found && /^[[:space:]]+[0-9]+x[0-9]+/ && /\+/ {
            mode=$1
            sub(/[+*].*$/, "", mode)
            print mode
            exit
        }

        found && /^[^[:space:]]/ {
            exit
        }
    ')

# Auto = preferred mode.
# If xrandr does not provide one, fall back to current mode.
auto_mode="$preferred"

[ -n "$auto_mode" ] || auto_mode="$current"

# Final fallback: first available mode.
[ -n "$auto_mode" ] || auto_mode=$(printf '%s\n' "$modes" | head -n 1)

choice=$(
    {
        printf 'AUTO → %s\n' "$auto_mode"
        printf '%s\n' "$modes"
    } |
    rofi -dmenu \
        -i \
        -p "DISPLAY" \
        -mesg "Current: ${current:-unknown}" \
        -theme "$THEME"
)

[ -n "$choice" ] || exit 0

case "$choice" in
    AUTO\ →\ *)
        target="$auto_mode"
        ;;
    *)
        target="$choice"
        ;;
esac

if xrandr --output "$output" --mode "$target" >/dev/null 2>&1; then
    notify-send "DISPLAY" "Resolution: $target"
else
    notify-send -u critical "DISPLAY" "Failed to switch to $target"
fi
