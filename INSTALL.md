# FreeBSD Dotfiles — Installation

Installation guide for setting up these dotfiles on a fresh FreeBSD 15.x amd64 system.

> Tested on **FreeBSD 15.1 amd64**, primarily inside VMware.

---

## Requirements

The instructions assume:

- FreeBSD 15.x amd64
- A normal user account
- Working Internet access
- Access to a TTY/console
- `startx` will be used to start the X11 session
- No full desktop environment is required

---

## 1. Update the system and install Git

Become root:

```sh
su -
```

Update package metadata and packages:

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

## 2. Clone the repository

```sh
cd ~
git clone https://github.com/arimaforu/freebsd-dotfiles.git
cd freebsd-dotfiles
```

---

## 3. Install the desktop packages

Become root:

```sh
su -
```

Install the main X11 stack:

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
    doas \
    xclip \
    jq \
    basu \
    locate
```

Install Yazi:

```sh
pkg install -y yazi
```

### Yazi version note

If the default FreeBSD repository provides an older Yazi than the configuration expects, enable the `latest` repository:

```sh
mkdir -p /usr/local/etc/pkg/repos

cat > /usr/local/etc/pkg/repos/FreeBSD-latest.conf <<'EOF2'
FreeBSD-latest: {
    url: "pkg+https://pkg.FreeBSD.org/${ABI}/latest",
    mirror_type: "srv",
    signature_type: "fingerprints",
    fingerprints: "/usr/share/keys/pkg",
    enabled: yes
}
EOF2

pkg update -r FreeBSD-latest
pkg install -r FreeBSD-latest yazi
```

Return to the normal user:

```sh
exit
```

---

## 4. Add the user to the required groups

As root:

```sh
su -
```

Replace `YOUR_USERNAME` with the actual username:

```sh
pw groupmod wheel -m YOUR_USERNAME
pw groupmod video -m YOUR_USERNAME
```

Return to the user:

```sh
exit
```

Log out and back in after changing group membership.

Verify:

```sh
groups
```

---

## 5. Enable D-Bus

As root:

```sh
su -
sysrc dbus_enable="YES"
service dbus start
exit
```

---

## 6. Configure doas

The power menu uses `doas`.

As root:

```sh
su -
echo 'permit persist :wheel' > /usr/local/etc/doas.conf
chmod 600 /usr/local/etc/doas.conf
exit
```

Test:

```sh
doas id
```

---

## 7. VMware support

For a VMware virtual machine:

```sh
su -

pkg install -y \
    open-vm-tools \
    xf86-video-vmware \
    xf86-input-vmmouse

exit
```

The bspwm configuration starts `vmtoolsd` automatically when it is available.

---

## 8. Install the dotfiles

From the repository:

```sh
cd ~/freebsd-dotfiles
mkdir -p ~/.config
```

Copy configuration directories:

```sh
cp -r bspwm ~/.config/
cp -r sxhkd ~/.config/
cp -r polybar ~/.config/
cp -r rofi ~/.config/
cp -r dunst ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/
cp -r yazi ~/.config/
```

Copy X11 configuration:

```sh
cp .xinitrc ~/
cp .Xresources ~/
```

---

## 9. XTerm and SIXEL

The repository uses XTerm in VT340 mode so Yazi can use native SIXEL previews.

The normal terminal command is:

```sh
xterm -ti vt340
```

Yazi is launched with:

```sh
xterm -ti vt340 -e yazi
```

The `.Xresources` file contains the VT340/SIXEL settings.

Apply it with:

```sh
xrdb -merge ~/.Xresources
```

Verify the terminal:

```sh
xterm -ti vt340
```

Then inside it:

```sh
ya env
```

The important lines should indicate:

```text
sixel: true
Drivers.matches: Sixel
```

---

## 10. Create user directories

```sh
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Pictures/Screenshots
```

The bspwm configuration expects the wallpaper at:

```text
~/Pictures/Wallpapers/y2k.jpg
```

Place your own wallpaper there.

---

## 11. Make scripts executable

```sh
chmod +x ~/.xinitrc
chmod +x ~/.config/bspwm/bspwmrc

find ~/.config/bspwm/scripts -type f -exec chmod +x {} \;
find ~/.config/polybar/scripts -type f -exec chmod +x {} \;
find ~/.config/rofi/scripts -type f -exec chmod +x {} \;
```

---

## 12. Start X11

From the TTY:

```sh
startx
```

The session starts:

- bspwm
- sxhkd
- Polybar
- Rofi
- Dunst
- Picom
- feh wallpaper
- X11 resource configuration
- background helper scripts

---

## 13. Locate database

The Rofi file-search script can use `locate`.

Initialize it as root:

```sh
su -
/usr/libexec/locate.updatedb
exit
```

Test:

```sh
locate xterm
```

The shortcut is:

```text
Ctrl + Alt + F
```

---

## 14. Verify terminal and Yazi

Open XTerm:

```sh
xterm -ti vt340
```

Check:

```sh
echo "$TERM"
```

Expected:

```text
xterm
```

Start Yazi:

```sh
xterm -ti vt340 -e yazi
```

Then select an image. The preview pane should show the actual image through SIXEL.

---

## 15. Updating the dotfiles

After pulling repository changes:

```sh
cd ~/freebsd-dotfiles
git pull --rebase
```

Copy changed configurations back into the system as needed.

Examples:

```sh
cp sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
cp .Xresources ~/.Xresources
xrdb -merge ~/.Xresources
```

Restart sxhkd:

```sh
pkill sxhkd
sxhkd &
```

For a complete desktop restart, use:

```text
Super + Shift + R
```

---

## Troubleshooting

### Yazi does not detect SIXEL

Start XTerm explicitly in VT340 mode:

```sh
xterm -ti vt340
```

Then:

```sh
ya env
```

Look for:

```text
sixel: true
Drivers.matches: Sixel
```

### Yazi shows broken image escape sequences

Make sure Yazi is running inside XTerm VT340:

```sh
xterm -ti vt340 -e yazi
```

Do not run it through a terminal that advertises another graphics protocol unless that terminal is intentionally being used.

### Transparent XTerm background does not work

Make sure Picom is running:

```sh
pgrep picom
```

Then restart the bspwm session:

```text
Super + Shift + R
```

### Start the desktop manually

```sh
startx
```

---

## Notes

This repository is a personal FreeBSD X11 configuration built around:

```text
FreeBSD
bspwm
sxhkd
Polybar
Rofi
Dunst
XTerm
Yazi
```

No full desktop environment is required.
