# FreeBSD Dotfiles

My personal **FreeBSD 15.1** desktop configuration.

A dark **Y2K / UNIX-inspired** setup built around `bspwm`, `sxhkd`, and `Polybar`.

The goal of this repository is to make it possible to reproduce the desktop on a **fresh FreeBSD installation** without having to guess which packages or settings are required.

> Tested on **FreeBSD 15.1 amd64**, primarily inside VMware.

---

## Main Components

| Component | Software |
|---|---|
| OS | FreeBSD 15.1 |
| Window Manager | bspwm |
| Hotkeys | sxhkd |
| Status Bar | Polybar |
| Application Launcher | Rofi |
| Notifications | Dunst |
| Terminal | xterm |
| File Manager | Thunar |
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
- Cyan accent color
- 9 bspwm workspaces
- Rofi application launcher
- EN / RU keyboard switching with `Alt + Shift`
- Network upload/download speed
- Volume and mute indicator
- CPU and RAM usage
- Date and time
- Dunst notifications
- Screenshot shortcuts
- Thunar file manager
- Custom XTerm appearance
- Power menu
- VMware guest integration
- Configuration stored in one Git repository

---

## Installation

For a complete installation guide on a fresh FreeBSD system, see **[INSTALL.md](INSTALL.md)**.

The guide covers package installation, user groups, D-Bus, `doas`, VMware support, dotfile installation, wallpaper setup, script permissions, `startx`, and optional `locate` setup.

---

# Keybindings

## Applications

| Shortcut | Action |
|---|---|
| `Super + Enter` | Open terminal |
| `Super + E` | Open Thunar |
| `Ctrl + Alt + D` | Rofi application launcher |
| `Super + Shift + P` | Power menu |
| `Ctrl + Alt + F` | File search |
| `Ctrl + Alt + W` | Window switcher |
| `Ctrl + Alt + S` | Workspace switcher |

`Super` normally means the Windows key.

---

## Windows

| Shortcut | Action |
|---|---|
| `Super + Shift + Q` | Close window |
| `Super + H` | Focus left |
| `Super + J` | Focus down |
| `Super + K` | Focus up |
| `Super + L` | Focus right |
| `Super + Shift + H` | Move window left |
| `Super + Shift + J` | Move window down |
| `Super + Shift + K` | Move window up |
| `Super + Shift + L` | Move window right |
| `Super + Shift + Space` | Toggle floating |

---

## Workspaces

There are 9 workspaces:

| Shortcut | Action |
|---|---|
| `Super + 1..9` | Switch workspace |
| `Super + Shift + 1..4` | Move current window to workspace 1-4 |

### Important

The current `sxhkdrc` only defines window-move shortcuts for workspaces **1-4**.

Workspaces **5-9** can still be selected with:

```text
Super + 5..9
```

or through the workspace switcher:

```text
Ctrl + Alt + S
```

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

The layout configuration is defined in `.xinitrc`.

---

# Power Menu

`Super + Shift + P` opens the Rofi power menu.

The intended actions are:

```text
Shutdown
Reboot
Logout
```

The current power-menu script also contains a `Lock` entry, but no lock command is implemented for it yet.

Shutdown and reboot use `doas`.

---

# Notes

This is a **personal FreeBSD desktop configuration**, not a universal FreeBSD desktop distribution.

It was created and tested on:

```text
FreeBSD 15.1 amd64
```

primarily inside VMware.

Depending on the machine, you may need to adjust:

- display resolution
- keyboard layout
- graphics drivers
- VMware settings
- wallpaper path
- hardware-specific settings
- user-specific paths

The configuration intentionally uses a relatively small X11 stack instead of a full desktop environment such as KDE Plasma or GNOME.

---

# License

Use, modify, copy, and break it however you want.

This repository exists primarily so I can reproduce my FreeBSD setup without configuring everything from scratch again.

---

Made with **FreeBSD**, **bspwm**, and too much time spent tweaking pixels.
