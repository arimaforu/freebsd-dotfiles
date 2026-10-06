# FreeBSD Dotfiles

Personal **FreeBSD 15.1** desktop configuration.

A dark **Y2K / UNIX-inspired** X11 setup built around `bspwm`, `sxhkd`, and `Polybar`.

The repository is designed to reproduce the desktop configuration on a fresh FreeBSD installation without rebuilding the setup from scratch.

> Tested on **FreeBSD 15.1 amd64**, primarily inside VMware.

---

## Main Components

| Component | Software |
|---|---|
| OS | FreeBSD 15.1 |
| Window Manager | bspwm |
| Hotkeys | sxhkd |
| Status Bar | Polybar |
| Terminal | XTerm |
| File Manager | Yazi |
| Application Launcher | Rofi |
| Notifications | Dunst |
| Browser | Firefox |
| Compositor | Picom |
| Wallpaper | feh |
| Screenshots | scrot |
| GTK Theme | Matcha Dark |
| Icons | Yaru Dark |
| Fonts | DejaVu Sans / Font Awesome |

---

## Features

- Dark Y2K / UNIX aesthetic
- Cyan window borders and accents
- 9 bspwm workspaces
- Automatic multi-monitor desktop distribution
- EN / RU keyboard switching with `Alt + Shift`
- XTerm with VT340/SIXEL support
- Yazi with native SIXEL image previews
- Transparent XTerm background
- Rofi application launcher
- Clipboard history
- Notification history
- Audio output switcher
- Automatic headphone volume handling
- Display resolution switcher
- Refresh-rate switcher
- Network connection/status indicator
- CPU and RAM usage
- Screenshot shortcuts
- Power menu
- VMware guest integration
- Configuration stored in one Git repository

---

# Keybindings

`Super` means the Windows/Meta key.

## Applications

| Shortcut | Action |
|---|---|
| `Super + T` | Open XTerm |
| `Super + B` | Open Firefox |
| `Super + E` | Open Yazi in XTerm |
| `Super + Q` | Close current window |
| `Super + V` | Clipboard history |
| `Super + Shift + Q` | Power menu |
| `Ctrl + Alt + D` | Rofi application launcher |
| `Ctrl + Alt + F` | File search |
| `Ctrl + Alt + W` | Window switcher |
| `Ctrl + Alt + S` | Workspace switcher |
| `Ctrl + Alt + N` | Notification history |
| `Ctrl + Alt + A` | Audio output switcher |
| `Ctrl + Alt + H` | Refresh-rate switcher |
| `Ctrl + Alt + R` | Display resolution switcher |
| `Super + Shift + R` | Restart desktop |

---

## Window Focus

| Shortcut | Action |
|---|---|
| `Super + H` | Focus left |
| `Super + J` | Focus down |
| `Super + K` | Focus up |
| `Super + L` | Focus right |

---

## Move Windows

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

---

## Workspaces

| Shortcut | Action |
|---|---|
| `Super + 1..9` | Switch workspace |
| `Super + Shift + 1..9` | Move current window to workspace |

---

## Screenshots

| Shortcut | Action |
|---|---|
| `Print` | Full-screen screenshot |
| `Shift + Print` | Select an area |
| `Alt + Print` | Active window |

Screenshots are saved to:

```text
~/Pictures/Screenshots/
```

---

## Keyboard Layout

```text
Alt + Shift
```

Switches between:

```text
EN
RU
```

The layout is configured in `.xinitrc`.

---

## Terminal and Yazi

XTerm is started in VT340 mode:

```sh
xterm -ti vt340
```

Yazi is started as:

```sh
xterm -ti vt340 -e yazi
```

VT340 mode enables SIXEL support, allowing Yazi to display image previews as real images instead of Unicode/ASCII previews.

---

## Audio

The desktop includes:

- Polybar volume indicator
- Output-device switcher
- Automatic headphone volume handling

Headphone/speaker volume defaults are configured in:

```text
bspwm/scripts/audio-watch.sh
```

---

## Display

The configuration includes Rofi-based tools for:

- changing display resolution;
- changing refresh rate;
- automatically selecting the highest available refresh rate.

The scripts use modes reported by `xrandr` instead of hardcoding a specific monitor.

---

## Clipboard

Clipboard history is stored under:

```text
~/.cache/freebsd-dotfiles/
```

`Super + V` opens the history through Rofi.

---

## Notifications

Dunst keeps notification history.

```text
Ctrl + Alt + N
```

opens notification history.

---

## Power Menu

```text
Super + Shift + Q
```

opens the Rofi power menu.

Available actions:

```text
Shutdown
Reboot
Logout
```

Shutdown and reboot use `doas`.

---

## Repository Structure

```text
.Xresources
.xinitrc
README.md
INSTALL.md

bspwm/
sxhkd/
polybar/
rofi/
dunst/
gtk-3.0/
gtk-4.0/
yazi/
shell/

check-dependencies.sh
busctl
```

---

## Notes

This is a **personal FreeBSD desktop configuration**, not a full desktop distribution.

It was created and tested on:

```text
FreeBSD 15.1 amd64
```

primarily inside VMware.

Hardware-specific parts may need adjustment on another machine, especially:

- graphics drivers;
- VMware integration;
- display modes;
- audio devices;
- wallpaper path.

The configuration intentionally uses a small X11 stack instead of KDE Plasma, GNOME, XFCE desktop, or another full desktop environment.

---

## License

Use, modify, copy, and break it however you want.

This repository exists primarily so the setup can be reproduced without configuring everything from scratch again.

---

Made with **FreeBSD**, **bspwm**, and too much time spent tweaking pixels.
