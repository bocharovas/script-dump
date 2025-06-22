#!/bin/sh

export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

rm -rf ~/.config/google-chrome/Default/Sessions

sleep 30   

env LANG=de_DE.UTF-8 /usr/bin/google-chrome-stable \
  --new-window \
  --no-first-run \
  --disable-session-crashed-bubble \
  --restore-last-session=false \
 https://chatgpt.com/
