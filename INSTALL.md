# FreeBSD Dotfiles — Installation

Complete installation guide for setting up these dotfiles on a fresh FreeBSD system.

> Tested on **FreeBSD 15.1 amd64**, primarily inside VMware.

---

## Installation on a Fresh FreeBSD System

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
pkg install -y xorg xinit setxkbmap xrdb xsetroot bspwm sxhkd polybar rofi dunst libnotify xterm thunar firefox picom feh scrot xdotool wmctrl xdg-utils font-awesome matcha-gtk-themes yaru-icon-theme dbus doas
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
