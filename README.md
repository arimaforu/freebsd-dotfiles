# FreeBSD Dotfiles

My personal FreeBSD desktop configuration.

A dark Y2K / UNIX-inspired setup built around **bspwm**, **sxhkd**, and **Polybar**.

## Components

| Component | Software |
|---|---|
| OS | FreeBSD 15.1 |
| Window Manager | bspwm |
| Hotkeys | sxhkd |
| Bar | Polybar |
| Launcher | Rofi |
| Notifications | Dunst |
| Terminal | xterm |
| File Manager | Thunar |
| Browser | Firefox |
| Compositor | Picom |
| Wallpaper | feh |
| GTK Theme | Matcha Dark |
| Icons | Yaru Dark |
| Font | DejaVu Sans |

## Features

- Dark Y2K / UNIX aesthetic
- Cyan accent color
- 9 bspwm workspaces
- Rofi application launcher
- EN / RU keyboard layout switching
- Network upload/download speed
- Volume and mute indicator
- CPU and RAM usage
- Windows-style date and time
- Dunst notifications
- Screenshot shortcuts
- Thunar file manager
- VMware clipboard integration

## Color Scheme

```text
Background  #0B0C0F
Foreground  #E6E6E6
Muted       #707780
Border      #272B31
Accent      #00E6D0
```

## Keybindings

### Applications

| Shortcut | Action |
|---|---|
| `Super + Enter` | Terminal |
| `Super + Shift + P` | Power menu |
| `Super + E` | File manager |
| `Ctrl + Alt + D` | Rofi launcher |

### Windows

| Shortcut | Action |
|---|---|
| `Super + Shift + Q` | Close window |
| `Super + H/J/K/L` | Focus window |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Shift + Space` | Toggle floating |

### Workspaces

| Shortcut | Action |
|---|---|
| `Super + 1..9` | Switch workspace |
| `Super + Shift + 1..9` | Move window to workspace |

### Screenshots

| Shortcut | Action |
|---|---|
| `Print` | Full screen |
| `Shift + Print` | Select area |
| `Alt + Print` | Active window |

## Installation

Clone the repository:

```sh
git clone https://github.com/arimaforu/freebsd-dotfiles.git
cd freebsd-dotfiles
```

Copy the configurations:

```sh
cp -r bspwm ~/.config/
cp -r sxhkd ~/.config/
cp -r polybar ~/.config/
cp -r rofi ~/.config/
cp -r dunst ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/

cp .xinitrc ~/
cp .Xresources ~/
```

Install the required packages:

```sh
sudo pkg install \
    bspwm \
    sxhkd \
    polybar \
    rofi \
    dunst \
    xterm \
    thunar \
    firefox \
    picom \
    feh \
    scrot \
    font-awesome \
    matcha-gtk-themes \
    yaru-icon-theme
```

Start X:

```sh
startx
```

## Notes

This configuration was made for my personal FreeBSD VM and may require adjustments for different hardware, displays, or VMware settings.

---

Made with FreeBSD, bspwm, and too much time spent tweaking pixels.
