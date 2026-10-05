#!/bin/sh

xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option grp:alt_shift_toggle

exec bspwm
