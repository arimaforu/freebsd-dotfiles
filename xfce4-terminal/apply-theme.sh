#!/bin/sh

xfconf-query -c xfce4-terminal -p /background-mode \
    --create -t string -s TERMINAL_BACKGROUND_TRANSPARENT

xfconf-query -c xfce4-terminal -p /background-darkness \
    --create -t double -s 0.85

xfconf-query -c xfce4-terminal -p /color-background \
    --create -t string -s "#0B0C0F"

xfconf-query -c xfce4-terminal -p /color-foreground \
    --create -t string -s "#E6E6E6"

xfconf-query -c xfce4-terminal -p /color-cursor \
    --create -t string -s "#00E6D0"

xfconf-query -c xfce4-terminal -p /misc-menubar-default \
    --create -t bool -s false

xfconf-query -c xfce4-terminal -p /misc-toolbar-default \
    --create -t bool -s false

xfconf-query -c xfce4-terminal -p /misc-show-unsafe-paste-dialog \
    --create -t bool -s false
