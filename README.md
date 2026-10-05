# FreeBSD Dotfiles

My personal **FreeBSD 15.1** desktop configuration.

A dark **Y2K / UNIX-inspired** setup built around `bspwm`, `sxhkd`, and `Polybar`.

The goal of this repository is to make it possible to reproduce the desktop on a **fresh FreeBSD installation** without having to guess which packages or settings are required.

> Tested on **FreeBSD 15.1 amd64**, primarily inside VMware.

---

## Preview

Add a screenshot to the repository later as:

```text
screenshot.png
```

The desktop is built from:

```text
FreeBSD
├── bspwm
├── sxhkd
├── Polybar
├── Rofi
├── Dunst
├── Picom
├── XTerm
└── GTK / Yaru Dark
```

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

## Color Scheme

```text
Background  #0B0C0F
Foreground  #E6E6E6
Muted       #707780
Border      #272B31
Accent      #00E6D0
```

---

# Installation on a Fresh FreeBSD System

This section is intended for a newly installed FreeBSD system with no desktop environment configured yet.

The instructions assume:

- FreeBSD **15.x amd64**
- A normal user account
- Working Internet access
- You are currently working from a TTY/console
- You want to start X11 with `startx`
- KDE, GNOME, XFCE, or another desktop environment is not installed

The examples below use:

```text
YOUR_USERNAME
```

Replace it with your actual FreeBSD username.

---

## 1. Log in as your normal user

For example:

```text
login: user
password: ********
```

Check the system:

```sh
uname -a
```

You should see FreeBSD information.

Check your username:

```sh
whoami
```

Remember this username for the `wheel` and `video` group steps below.

---

## 2. Become root

FreeBSD does not require `sudo` for the base installation.

Run:

```sh
su -
```

Enter the root password.

---

## 3. Update the package repository

As root:

```sh
pkg update
pkg upgrade
```

Install Git:

```sh
pkg install -y git
```

Return to your normal user:

```sh
exit
```

---

## 4. Clone the repository

As your normal user:

```sh
cd ~
git clone https://github.com/arimaforu/freebsd-dotfiles.git
cd freebsd-dotfiles
```

Check the repository:

```sh
ls
```

You should see files such as:

```text
.Xresources
.xinitrc
README.md
bspwm/
sxhkd/
polybar/
rofi/
dunst/
gtk-3.0/
gtk-4.0/
```

---

# 5. Install the required software

Become root again:

```sh
su -
```

Install the complete X11 desktop stack used by the configuration:

```sh
pkg install -y \
    xorg \
    xinit \
    setxkbmap \
    xrdb \
    xsetroot \
    bspwm \
    sxhkd \
    polybar \
    rofi \
    dunst \
    libnotify \
    xterm \
    thunar \
    firefox \
    picom \
    feh \
    scrot \
    xdotool \
    wmctrl \
    xdg-utils \
    font-awesome \
    matcha-gtk-themes \
    yaru-icon-theme \
    dbus \
    doas
```

These packages cover the commands and applications referenced directly by the dotfiles.

In particular:

- `setxkbmap` is used by `.xinitrc`
- `xrdb` loads `.Xresources`
- `xsetroot` is used by `bspwmrc`
- `xdotool` is used by the Polybar window controls
- `wmctrl` is used by the Rofi window switcher
- `xdg-utils` provides `xdg-open`
- `libnotify` provides `notify-send`

---

# 6. Add your user to `wheel` and `video`

The graphical X11 session requires the user to be a member of the `video` group.

As root:

```sh
pw groupmod wheel -m YOUR_USERNAME
pw groupmod video -m YOUR_USERNAME
```

Verify later after logging in again with:

```sh
groups
```

You should see at least:

```text
wheel video
```

Log out and log back in after changing the groups.

---

# 7. Enable D-Bus

D-Bus provides desktop integration used by various X11 and GTK applications.

As root:

```sh
sysrc dbus_enable="YES"
service dbus start
```

---

# 8. Configure `doas`

The power menu uses `doas` for shutdown and reboot.

Create the configuration:

```sh
echo 'permit persist :wheel' > /usr/local/etc/doas.conf
chmod 600 /usr/local/etc/doas.conf
```

After returning to your normal user, test it with:

```sh
doas id
```

Enter your password when requested.

The command should report that the command is running as root.

---

# 9. VMware support

The current `bspwm/bspwmrc` starts:

```sh
/usr/local/bin/vmtoolsd -n vmusr &
```

Because of this, the current configuration expects VMware Tools to be installed.

For a VMware virtual machine, install:

```sh
pkg install -y \
    open-vm-tools \
    xf86-video-vmware \
    xf86-input-vmmouse
```

Then return to your normal user:

```sh
exit
```

For a physical computer or another hypervisor, the `vmtoolsd` line in `~/.config/bspwm/bspwmrc` should be removed or changed to a conditional command.

The rest of the dotfiles do not depend on VMware.

---

# 10. Install the dotfiles

Return to your normal user:

```sh
exit
```

Go to the repository:

```sh
cd ~/freebsd-dotfiles
```

Create the configuration directory:

```sh
mkdir -p ~/.config
```

Copy the desktop configurations:

```sh
cp -r bspwm ~/.config/
cp -r sxhkd ~/.config/
cp -r polybar ~/.config/
cp -r rofi ~/.config/
cp -r dunst ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/
```

Copy the X11 configuration:

```sh
cp .xinitrc ~/
cp .Xresources ~/
```

---

# 11. Create user directories

The configuration expects a wallpaper and a screenshot directory.

Create them:

```sh
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Pictures/Screenshots
```

The current `bspwmrc` expects the wallpaper at:

```text
~/Pictures/Wallpapers/y2k.jpg
```

The wallpaper itself is **not included in this repository**.

Put your own wallpaper there:

```text
~/Pictures/Wallpapers/y2k.jpg
```

If that file does not exist, `feh` will report an error when bspwm starts, but the rest of the desktop can still run.

---

# 12. Make scripts executable

Run:

```sh
chmod +x ~/.xinitrc
chmod +x ~/.config/bspwm/bspwmrc

find ~/.config/bspwm/scripts -type f -exec chmod +x {} \;
find ~/.config/polybar/scripts -type f -exec chmod +x {} \;
find ~/.config/rofi/scripts -type f -exec chmod +x {} \;
```

---

# 13. Start the graphical desktop

From the TTY, run:

```sh
startx
```

The session should start with:

- bspwm
- sxhkd
- Polybar
- Rofi
- Dunst
- Picom
- feh wallpaper
- GTK settings
- XTerm configuration

If everything is installed correctly, you should be dropped directly into the bspwm desktop.

---

# 14. Optional: update the `locate` database

The Rofi file-search script uses `locate`.

On a fresh FreeBSD installation, the `locate` database may not have been generated yet. FreeBSD provides the update utility at:

```text
/usr/libexec/locate.updatedb
```

Run it as root:

```sh
su -
/usr/libexec/locate.updatedb
exit
```

You can then test it with:

```sh
locate xterm
```

The file search shortcut is:

```text
Ctrl + Alt + F
```

FreeBSD normally rebuilds the `locate` database periodically, so this step is optional rather than required for the initial desktop installation.

---

# 15. Check `.xinitrc` after the first `startx`

The repository provides:

```sh
xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option grp:alt_shift_toggle

exec bspwm
```

This does three things:

1. Loads the XTerm/X11 settings
2. Enables US/Russian keyboard layouts
3. Starts bspwm

Normally you do not need to edit this file.

If `startx` fails, inspect it from the TTY:

```sh
cat ~/.xinitrc
```

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

# Updating the Configuration

After changing files in the repository:

```sh
cd ~/freebsd-dotfiles
git status
git add .
git commit -m "Update configuration"
git push
```

On another machine:

```sh
cd ~/freebsd-dotfiles
git pull
```

Then copy the updated files into your home directory again:

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

Restart X afterward:

```sh
startx
```

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
