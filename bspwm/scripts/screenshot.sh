#!/bin/sh

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

case "$1" in
    full)
        file="$DIR/$(date '+%Y-%m-%d_%H-%M-%S').png"
        scrot "$file"
        notify-send -i "$file" "SCREENSHOT" "Saved: $(basename "$file")"
        ;;
    area)
        file="$DIR/$(date '+%Y-%m-%d_%H-%M-%S').png"
        scrot -s "$file"
        notify-send -i "$file" "SCREENSHOT" "Selected area saved"
        ;;
    window)
        file="$DIR/$(date '+%Y-%m-%d_%H-%M-%S').png"
        scrot -u "$file"
        notify-send -i "$file" "SCREENSHOT" "Window saved"
        ;;
esac
