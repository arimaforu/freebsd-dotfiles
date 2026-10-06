# FreeBSD Dotfiles — Installation

Installation guide for deploying this configuration on a fresh **FreeBSD 15.x amd64** installation.

> Tested on **FreeBSD 15.1 amd64**, primarily in VMware.

The configuration uses X11 and `startx`. No KDE, GNOME, XFCE or other full desktop environment is required.

---

# 1. Requirements

You need:

- FreeBSD 15.x amd64
- a normal user account
- working Internet access
- a TTY/console
- `root` access through `su`

This is a FreeBSD-specific X11 configuration, not a generic Linux dotfiles setup.

---

# 2. Update the system and install Git

Switch to root:

```sh
su -
```

Update packages:

```sh
pkg update
pkg upgrade
```

Install Git:

```sh
pkg install -y git
```

Return to the normal user:

```sh
exit
```

---

# 3. Clone the repository

```sh
cd ~
git clone https://github.com/arimaforu/freebsd-dotfiles.git
cd freebsd-dotfiles
```

Repository path:

```text
~/freebsd-dotfiles
```

---

# 4. Install the desktop packages

Become root:

```sh
su -
```

Install the main stack:

```sh
pkg install -y     xorg     xinit     setxkbmap     xrdb     xsetroot     bspwm     sxhkd     polybar     rofi     dunst     libnotify     xterm     firefox     picom     feh     scrot     xdotool     wmctrl     xdg-utils     xclip     jq     font-awesome     matcha-gtk-themes     yaru-icon-theme     dbus     doas     locate     thunar     yazi
```

`thunar` is used by the file-search helper for directories. Yazi is the primary file manager used by the desktop shortcut.

---

# 5. Optional Yazi latest repository

Normally the standard FreeBSD repository is enough.

If you specifically need a newer Yazi build from `latest`:

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

Use this only when the normal repository version is not suitable.

---

# 6. Add the user to required groups

Replace `YOUR_USERNAME` with your actual username.

```sh
pw groupmod wheel -m YOUR_USERNAME
pw groupmod video -m YOUR_USERNAME
```

Check:

```sh
groups YOUR_USERNAME
```

Log out and back in after changing group membership.

---

# 7. Enable D-Bus

As root:

```sh
sysrc dbus_enable="YES"
service dbus start
```

Return to the normal user:

```sh
exit
```

The X session is started through `dbus-run-session` in `.xinitrc`.

---

# 8. Configure doas

The power menu uses `doas` for shutdown and reboot.

As root:

```sh
su -
cat > /usr/local/etc/doas.conf <<'EOF2'
permit persist :wheel
EOF2
chmod 600 /usr/local/etc/doas.conf
exit
```

Test:

```sh
doas id
```

---

# 9. VMware support — optional

Only needed inside VMware.

```sh
su -

pkg install -y     open-vm-tools     xf86-video-vmware     xf86-input-vmmouse

exit
```

When available, `bspwmrc` starts `vmtoolsd -n vmusr` automatically.

---

# 10. Install the dotfiles

Create the configuration directory:

```sh
mkdir -p ~/.config
```

From the repository:

```sh
cd ~/freebsd-dotfiles
```

Copy the configuration directories:

```sh
cp -r bspwm ~/.config/
cp -r sxhkd ~/.config/
cp -r polybar ~/.config/
cp -r rofi ~/.config/
cp -r dunst ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r gtk-4.0 ~/.config/
cp -r yazi ~/.config/
cp -r fastfetch ~/.config/
```

Copy X11 configuration:

```sh
cp .xinitrc ~/.xinitrc
cp .Xresources ~/.Xresources
```

---

# 11. Wallpaper and screenshot directories

```sh
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Pictures/Screenshots
```

The bspwm configuration expects:

```text
~/Pictures/Wallpapers/y2k.jpg
```

Put your own wallpaper there. The wallpaper is intentionally not included in the repository.

---

# 12. Make scripts executable

```sh
chmod +x ~/.xinitrc
chmod +x ~/.config/bspwm/bspwmrc

find ~/.config/bspwm/scripts -type f -exec chmod +x {} \;
find ~/.config/polybar/scripts -type f -exec chmod +x {} \;
find ~/.config/rofi/scripts -type f -exec chmod +x {} \;

chmod +x ~/freebsd-dotfiles/scripts/hotplug-notify.sh
```

---

# 13. Run the dependency checker

```sh
cd ~/freebsd-dotfiles
sh check-dependencies.sh
```

The checker only reports missing dependencies. It does not install or modify anything.

---

# 14. Fastfetch — optional

Create the directory:

```sh
mkdir -p ~/.config/fastfetch
```

Copy the configuration:

```sh
cp ~/freebsd-dotfiles/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
```

Test:

```sh
fastfetch
```

---

# 15. Shell prompt — optional

The repository contains:

```text
shell/prompt.sh
```

For a POSIX-compatible shell, source it from your shell configuration:

```sh
. ~/freebsd-dotfiles/shell/prompt.sh
```

This does not affect the X11 desktop.

---

# 16. XTerm and SIXEL

Apply X resources:

```sh
xrdb -merge ~/.Xresources
```

Test XTerm:

```sh
xterm -ti vt340
```

Yazi is launched as:

```sh
xterm -ti vt340 -e yazi
```

`.Xresources` contains the terminal palette, font, clipboard bindings and VT340/SIXEL-related options.

---

# 17. Test Yazi

```sh
xterm -ti vt340 -e yazi
```

Open a directory containing an image and check the preview pane.

You can also inspect the environment with:

```sh
ya env
```

---

# 18. Configure file search

The Rofi file-search helper uses the FreeBSD `locate` database.

As root:

```sh
su -
/usr/libexec/locate.updatedb
exit
```

Test:

```sh
locate xterm
```

Shortcut:

```text
Ctrl + Alt + F
```

Directories are opened with Thunar; files are opened through `xdg-open`.

---

# 19. USB hotplug notifications — optional

The repository contains:

```text
devd/hotplug.conf
scripts/hotplug-notify.sh
```

The helper currently contains:

```sh
USER_NAME="user"
```

Change this to the actual desktop username before enabling the feature.

Then:

```sh
chmod +x ~/freebsd-dotfiles/scripts/hotplug-notify.sh
```

Create the command expected by `devd`:

```sh
su -
ln -sf /home/YOUR_USERNAME/freebsd-dotfiles/scripts/hotplug-notify.sh /usr/local/bin/dotfiles-hotplug
exit
```

Replace `YOUR_USERNAME` with your real username.

Install the rule:

```sh
su -
cp ~/freebsd-dotfiles/devd/hotplug.conf /usr/local/etc/devd/dotfiles-hotplug.conf
service devd restart
exit
```

This feature is optional and is not required for the rest of the desktop.

---

# 20. Start X11

From a TTY, log in as the normal user and run:

```sh
startx
```

`.xinitrc`:

1. loads `.Xresources`;
2. configures US/Russian layouts;
3. sets the X11 cursor;
4. starts `bspwm` inside `dbus-run-session`.

`bspwmrc` then starts:

```text
sxhkd
Polybar
Dunst
Picom
feh
clipboard daemon
audio watcher
desktop watchdog
VMware tools (when available)
```

---

# 21. First checks

Test the main shortcuts:

```text
Super + T
Super + B
Super + E
Ctrl + Alt + D
Super + 1..9
Super + V
Ctrl + Alt + A
Ctrl + Alt + R
Ctrl + Alt + H
```

---

# 22. Restarting the desktop

```text
Super + Shift + R
```

This runs:

```sh
bspc wm -r
```

---

# 23. Updating the dotfiles

Update the repository:

```sh
cd ~/freebsd-dotfiles
git pull --rebase
```

Copy changed files back into place as needed:

```sh
cp sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
cp polybar/config.ini ~/.config/polybar/config.ini
cp rofi/theme.rasi ~/.config/rofi/theme.rasi
cp .Xresources ~/.Xresources
```

Reload X resources:

```sh
xrdb -merge ~/.Xresources
```

Then restart bspwm:

```text
Super + Shift + R
```

---

# 24. Troubleshooting

## `startx` exits immediately

Check:

```sh
cat ~/.xinitrc
startx
```

For Xorg problems inspect the Xorg log under:

```text
~/.local/share/xorg/
```

## No Polybar

```sh
pgrep polybar
polybar y2k
```

## No keyboard shortcuts

```sh
pgrep sxhkd
sxhkd
```

## No notifications

```sh
pgrep dunst
notify-send "TEST" "Dunst is working"
```

## No Picom shadows/transparency

```sh
pgrep picom
```

Then restart the desktop with `Super + Shift + R`.

## Yazi image previews do not work

Run:

```sh
xterm -ti vt340
yazi
```

Verify that the installed XTerm/Yazi combination supports the expected graphics protocol.

## Audio output switching does not work

Check:

```sh
cat /dev/sndstat
sysctl hw.snd.default_unit
mixer
```

The selector relies on FreeBSD `pcm` devices.

## Headphone auto-volume does not work

The watcher reads FreeBSD HDA information from:

```sh
dmesg -a
```

and may need hardware-specific adjustment.

Script:

```text
~/.config/bspwm/scripts/audio-watch.sh
```

## File search does nothing

Update `locate`:

```sh
su -
/usr/libexec/locate.updatedb
exit
```

Then:

```sh
locate xterm
```

---

# 25. Core installation vs optional features

Core desktop:

```text
Xorg
bspwm
sxhkd
Polybar
Rofi
Dunst
XTerm
Picom
feh
scrot
xclip
```

Optional features include:

- VMware integration;
- USB hotplug notifications;
- Fastfetch customization;
- shell prompt customization.

---

# 26. Final locations

Important user files:

```text
~/.xinitrc
~/.Xresources

~/.config/bspwm/
~/.config/sxhkd/
~/.config/polybar/
~/.config/rofi/
~/.config/dunst/
~/.config/gtk-3.0/
~/.config/gtk-4.0/
~/.config/yazi/
~/.config/fastfetch/
```

Generated user data:

```text
~/Pictures/Screenshots/
~/Pictures/Wallpapers/
~/.cache/freebsd-dotfiles/
```

---

# 27. Done

Start the desktop with:

```sh
startx
```

The intended session is:

```text
FreeBSD
   │
  Xorg
   │
 bspwm
   ├── sxhkd
   ├── Polybar
   ├── Rofi
   ├── Dunst
   ├── Picom
   ├── feh
   ├── clipboard daemon
   ├── audio watcher
   └── desktop watchdog
```

No full desktop environment is required.
