#!/bin/bash

BASE="$HOME/projects/script-dump/src"
BIN="$HOME/bin"
AUTOSTART="$HOME/.config/autostart"
SYSTEMD_USER="$HOME/.config/systemd/user"

mkdir -p "$BIN" "$AUTOSTART" "$SYSTEMD_USER"

echo "=== Creating symlinks with cleanup ==="

# autostart
for f in "$BASE/autostart/"*.desktop; do
  [ -e "$f" ] || continue
  ln_path="$AUTOSTART/$(basename "$f")"
  if [ -L "$ln_path" ]; then
    echo "🗑️  Removing old symlink: $ln_path"
    rm "$ln_path"
  elif [ -e "$ln_path" ]; then
    echo "⚠️  Exists file (not symlink), skipping: $ln_path"
    continue
  fi
  ln -s "$f" "$ln_path"
  echo "➕ Linked autostart: $ln_path"
done

# скрипты в ~/bin из всех папок
for subdir in util chrome bluetooth gits pic sys lua; do
  for f in "$BASE/$subdir/"*; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    name="${name%.sh}"  # убираем расширение .sh если есть
    ln_path="$BIN/$name"
    if [ -L "$ln_path" ]; then
      echo "🗑️  Removing old symlink: $ln_path"
      rm "$ln_path"
    elif [ -e "$ln_path" ]; then
      echo "⚠️  Exists file (not symlink), skipping: $ln_path"
      continue
    fi
    ln -s "$f" "$ln_path"
    echo "➕ Linked script: $ln_path"
  done
done

# systemd user services
for f in "$BASE/systemd/"*.service; do
  [ -e "$f" ] || continue
  ln_path="$SYSTEMD_USER/$(basename "$f")"
  if [ -L "$ln_path" ]; then
    echo "🗑️  Removing old symlink: $ln_path"
    rm "$ln_path"
  elif [ -e "$ln_path" ]; then
    echo "⚠️  Exists file (not symlink), skipping: $ln_path"
    continue
  fi
  ln -s "$f" "$ln_path"
  echo "➕ Linked systemd service: $ln_path"
done

echo "✅ All symlinks updated!"

