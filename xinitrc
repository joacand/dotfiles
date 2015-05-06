#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

### Autostart

# Keyboard
setxkbmap -layout se

trayer --edge top --align right --widthtype request --width 100 --SetDockType true --SetPartialStrut true --transparent true --alpha 0 --tint 0x000000 --expand true --heighttype pixel --height 18 &

nm-applet &                     # Sys tray app for networks
fanscript.sh &                  # Fan control
xfce4-power-manager &           # Power manager
sh ~/.fehbg &                   # Set wallpaper
wallpaper.sh &                  # Random wallpaper
volumeicon &                    # Volume icon
/opt/dropbox/dropboxd &         # Dropbox
keepass &                       # KeePass
xcompmgr &                      # Composite manager
xsetroot -cursor_name left_ptr  # Pointer
gnome-terminal                  # Terminal on start-up
xmonad                          # Start xmonad

# Keyboard
setxkbmap -layout se
