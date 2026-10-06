#!/bin/sh

xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option grp:alt_shift_toggle

if command -v dbus-launch >/dev/null 2>&1; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

exec bspwm
