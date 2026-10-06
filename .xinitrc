#!/bin/sh

xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option grp:alt_shift_toggle

xsetroot -cursor_name left_ptr

exec dbus-run-session -- bspwm
