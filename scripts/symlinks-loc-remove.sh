#!/bin/bash

echo "=== Cleaning up ~/.local/bin ==="

BIN_DIR="$HOME/.local/bin"

if [ ! -d "$BIN_DIR" ]; then
  echo "📂 Папка $BIN_DIR не существует, нечего чистить."
  exit 0
fi

FILES=$(find "$BIN_DIR" -type l)

if [ -z "$FILES" ]; then
  echo "✅ В $BIN_DIR нет симлинков."
  exit 0
fi

for file in $FILES; do
  echo "🗑️  Удаляю симлинк: $file"
  rm "$file"
done

echo "✅ Все симлинки из ~/.local/bin удалены."

