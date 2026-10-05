#!/bin/sh

# FreeBSD Dotfiles - dependency checker
# This script only checks dependencies.
# It does not install, remove, or modify anything.

set -u

required_missing=0
optional_missing=0

check_command() {
    name="$1"
    command_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        printf '[OK]     %-24s %s\n' "$name" "$command_name"
    else
        printf '[MISSING] %-22s %s\n' "$name" "$command_name"
        required_missing=$((required_missing + 1))
    fi
}

check_optional_command() {
    name="$1"
    command_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        printf '[OK]     %-24s %s\n' "$name" "$command_name"
    else
        printf '[OPTIONAL] %-20s %s\n' "$name" "$command_name"
        optional_missing=$((optional_missing + 1))
    fi
}

check_package() {
    name="$1"
    package="$2"

    if pkg info -e "$package" >/dev/null 2>&1; then
        printf '[OK]     %-24s %s\n' "$name" "$package"
    else
        printf '[MISSING] %-22s %s\n' "$name" "$package"
        required_missing=$((required_missing + 1))
    fi
}

printf '%s\n' 'FREEBSD DOTFILES // DEPENDENCY CHECK'
printf '%s\n' '==================================='
printf '\n'

printf '%s\n' '[ REQUIRED COMMANDS ]'
check_command 'bspwm control' 'bspc'
check_command 'hotkey daemon' 'sxhkd'
check_command 'terminal' 'xterm'
check_command 'launcher' 'rofi'
check_command 'file manager' 'thunar'
check_command 'bar' 'polybar'
check_command 'notifications' 'dunst'
check_command 'compositor' 'picom'
check_command 'wallpaper' 'feh'
check_command 'screenshots' 'scrot'
check_command 'window switcher' 'wmctrl'
check_command 'X properties' 'xprop'
check_command 'clipboard' 'xclip'
check_command 'notifications API' 'notify-send'
check_command 'audio mixer' 'mixer'
check_command 'X keyboard' 'setxkbmap'
check_command 'X resources' 'xrdb'
check_command 'X root' 'xsetroot'
check_command 'X session' 'startx'
check_command 'desktop opener' 'xdg-open'
check_command 'privilege helper' 'doas'

printf '\n%s\n' '[ REQUIRED PACKAGES ]'
check_package 'X11' 'xorg'
check_package 'X init' 'xinit'
check_package 'bspwm' 'bspwm'
check_package 'sxhkd' 'sxhkd'
check_package 'Polybar' 'polybar'
check_package 'Rofi' 'rofi'
check_package 'Dunst' 'dunst'
check_package 'libnotify' 'libnotify'
check_package 'xterm' 'xterm'
check_package 'Thunar' 'thunar'
check_package 'Firefox' 'firefox'
check_package 'Picom' 'picom'
check_package 'feh' 'feh'
check_package 'scrot' 'scrot'
check_package 'wmctrl' 'wmctrl'
check_package 'xdg-utils' 'xdg-utils'
check_package 'xclip' 'xclip'
check_package 'Font Awesome' 'font-awesome'
check_package 'Matcha GTK themes' 'matcha-gtk-themes'
check_package 'Yaru icons' 'yaru-icon-theme'
check_package 'D-Bus' 'dbus'
check_package 'doas' 'doas'

printf '\n%s\n' '[ OPTIONAL ]'
check_optional_command 'VMware tools' 'vmtoolsd'
check_optional_command 'locate' 'locate'

printf '\n'
printf 'Required missing: %d\n' "$required_missing"
printf 'Optional missing: %d\n' "$optional_missing"

if [ "$required_missing" -eq 0 ]; then
    printf '\n[READY] All required dependencies are installed.\n'
    exit 0
fi

printf '\n[NOT READY] Some required dependencies are missing.\n'
printf 'Install the missing packages, then run this checker again.\n'
exit 1
