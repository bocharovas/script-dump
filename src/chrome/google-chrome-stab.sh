#!/bin/sh

rm -rf ~/.config/google-chrome/Default/Sessions

sleep 2m

env LANG=de_DE.UTF-8 /usr/bin/google-chrome-stable \
  --new-window \
  --no-first-run \
  --disable-session-crashed-bubble \
  --restore-last-session=false \
 https://chatgpt.com/
