# FreeBSD Dotfiles

Personal **FreeBSD 15.1 amd64** desktop configuration built around a lightweight X11 stack.

A dark **Y2K / UNIX-inspired** desktop with `bspwm`, `sxhkd`, `Polybar`, `Rofi`, `Dunst` and `XTerm`.

> Tested on **FreeBSD 15.1 amd64**, primarily in VMware.

## Stack

| Component | Software |
|---|---|
| OS | FreeBSD 15.1 |
| Display server | Xorg |
| Window manager | bspwm |
| Hotkey daemon | sxhkd |
| Status bar | Polybar |
| Launcher | Rofi |
| Notifications | Dunst |
| Terminal | XTerm |
| File manager | Yazi |
| Browser | Firefox |
| Compositor | Picom |
| Wallpaper | feh |
| Screenshots | scrot |
| Clipboard | xclip |
| Window utilities | wmctrl / xdotool |
| GTK theme | Matcha Dark |
| Icon theme | Yaru Dark |
| Fonts | DejaVu Sans / Font Awesome |
| System information | Fastfetch |

## Features

- Dark Y2K / UNIX visual style
- Cyan accent color and bspwm borders
- 9 workspaces
- Automatic multi-monitor workspace distribution
- EN / RU keyboard layout with `Alt + Shift`
- XTerm VT340/SIXEL configuration
- Yazi image-preview integration
- Polybar system information and window controls
- Rofi application launcher and system utilities
- Dunst notification history
- Clipboard history
- FreeBSD audio output switching
- Automatic headphone/speaker volume profiles
- Resolution and refresh-rate switching
- Network status and traffic information
- CPU, RAM and battery information
- Screenshot shortcuts
- Power menu
- Optional VMware integration
- Optional FreeBSD `devd` USB hotplug notifications
- Desktop watchdog for helper processes
- Fastfetch configuration

## Keybindings

`Super` means the Windows / Meta key.

### Applications and utilities

| Shortcut | Action |
|---|---|
| `Super + T` | Open XTerm |
| `Super + B` | Open Firefox |
| `Super + E` | Open Yazi |
| `Super + Q` | Close current window |
| `Super + V` | Clipboard history |
| `Super + Shift + Q` | Power menu |
| `Super + Shift + R` | Restart bspwm desktop |
| `Ctrl + Alt + D` | Rofi application launcher |
| `Ctrl + Alt + F` | File search |
| `Ctrl + Alt + W` | Window switcher |
| `Ctrl + Alt + S` | Workspace switcher |
| `Ctrl + Alt + N` | Notification history |
| `Ctrl + Alt + A` | Audio output selector |
| `Ctrl + Alt + R` | Display resolution selector |
| `Ctrl + Alt + H` | Refresh-rate selector |

### Window focus

| Shortcut | Action |
|---|---|
| `Super + H` | Focus left |
| `Super + J` | Focus down |
| `Super + K` | Focus up |
| `Super + L` | Focus right |

### Move windows

| Shortcut | Action |
|---|---|
| `Super + Shift + H` | Move window left |
| `Super + Shift + J` | Move window down |
| `Super + Shift + K` | Move window up |
| `Super + Shift + L` | Move window right |
| `Super + Shift + ←` | Move window left |
| `Super + Shift + →` | Move window right |
| `Super + Shift + ↑` | Move window up |
| `Super + Shift + ↓` | Move window down |
| `Super + Shift + Space` | Toggle floating |

### Workspaces

| Shortcut | Action |
|---|---|
| `Super + 1..9` | Switch workspace |
| `Super + Shift + 1..9` | Move window to workspace |

### Screenshots

| Shortcut | Action |
|---|---|
| `Print` | Full-screen screenshot |
| `Shift + Print` | Select area |
| `Alt + Print` | Active window |

Screenshots are saved to:

```text
~/Pictures/Screenshots/
```

## Keyboard layout

Configured in `.xinitrc`:

```text
US + Russian
Alt + Shift
```

## Terminal and Yazi

XTerm is launched in VT340 mode:

```sh
xterm -ti vt340
```

Yazi is launched as:

```sh
xterm -ti vt340 -e yazi
```

`.Xresources` contains the terminal palette, font, clipboard bindings and SIXEL/VT340 settings. `yazi/theme.toml` provides the matching dark/cyan theme.

## Audio

The audio controls are FreeBSD-specific and use the native sound system:

- `mixer` for volume;
- `/dev/sndstat` for device discovery;
- `hw.snd.default_unit` for default output selection.

`bspwm/scripts/audio-watch.sh` watches headphone jack state and uses 40% for headphones and 70% for speakers by default.

## Display

The Rofi display tools use `xrandr` rather than hardcoded monitor models.

- `Ctrl + Alt + R` — resolution selector with an `AUTO` option.
- `Ctrl + Alt + H` — refresh-rate selector with an automatic highest-rate option.

## Clipboard history

`bspwm/scripts/clipboard-daemon.sh` keeps up to 50 clipboard entries and ignores entries larger than 1 MiB.

History:

```text
~/.cache/freebsd-dotfiles/clipboard-history
```

Open it with `Super + V`.

## Notifications

Dunst is configured with persistent history and a dark/cyan theme.

Configuration:

```text
dunst/dunstrc
```

History:

```text
Ctrl + Alt + N
```

## Fastfetch

Fastfetch configuration:

```text
fastfetch/config.jsonc
```

It shows host, kernel, uptime, shell, WM, CPU, GPU, RAM, disk, terminal, IP and colors.

## FreeBSD hotplug

The repository contains a FreeBSD `devd` rule:

```text
devd/hotplug.conf
scripts/hotplug-notify.sh
```

It can display USB attach/detach notifications through Dunst. This is optional and the helper contains a configurable desktop username.

## Desktop watchdog

`bspwm/scripts/desktop-watchdog.sh` checks `sxhkd`, `dunst`, `picom`, `polybar` and the clipboard daemon and attempts to restart them if they die.

Log:

```text
~/.cache/freebsd-dotfiles/watchdog.log
```

## VMware

When `vmtoolsd` is available, `bspwmrc` starts:

```sh
vmtoolsd -n vmusr
```

VMware-specific packages are optional on physical hardware.

## Repository structure

```text
freebsd-dotfiles/
├── .Xresources
├── .xinitrc
├── INSTALL.md
├── README.md
├── busctl
├── check-dependencies.sh
├── bspwm/
│   ├── bspwmrc
│   └── scripts/
├── devd/
│   └── hotplug.conf
├── dunst/
│   └── dunstrc
├── fastfetch/
│   └── config.jsonc
├── gtk-3.0/
├── gtk-4.0/
├── polybar/
│   ├── config.ini
│   └── scripts/
├── rofi/
│   ├── theme.rasi
│   └── scripts/
├── scripts/
│   └── hotplug-notify.sh
├── shell/
│   └── prompt.sh
├── sxhkd/
│   └── sxhkdrc
└── yazi/
    └── theme.toml
```

## Dependency checker

Run:

```sh
cd ~/freebsd-dotfiles
sh check-dependencies.sh
```

The checker only reports missing commands/packages; it does not install or modify anything.

## Compatibility

Primary target:

```text
FreeBSD 15.1 amd64
```

The configuration may require adjustments on other hardware, especially for graphics, audio, monitor modes, headphone jack detection, VMware and `devd` integration.

The wallpaper is not included. Place your own image at:

```text
~/Pictures/Wallpapers/y2k.jpg
```

## Installation

See [INSTALL.md](INSTALL.md).

## License

Use it, modify it, copy it, fork it, break it and rebuild it.

This repository exists primarily to keep the FreeBSD desktop reproducible.

---

Made with **FreeBSD**, **bspwm**, and an unreasonable amount of time spent tweaking the desktop.
