#!/bin/sh

export XCURSOR_THEME="Adwaita"
export XCURSOR_SIZE="24"
export XCURSOR_THEME_CORE="1"

xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option grp:alt_shift_toggle

xsetroot -cursor_name left_ptr

exec dbus-run-session -- bspwm
