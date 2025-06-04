#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 {install|update|backup|link}"
  exit 1
}

install() {
  echo "Running install..."

  if ! command -v git-crypt &> /dev/null; then
	    echo "git-crypt is not installed. Installing git-crypt..."
	    sudo apt update
	    sudo apt install -y git-crypt
  else
	   echo "git-crypt is already installed."	
  fi

  if git-crypt unlock; then
	    echo "git-crypt unlock successful: files are now decrypted."
  else
	    echo "git-crypt unlock failed. Make sure you have the correct GPG key."
	    exit 1
  fi

  if ! command -v pnpm &> /dev/null; then
    echo "pnpm is not installed."

    if command -v corepack &> /dev/null; then
      echo "Using corepack to install pnpm..."
      corepack enable
      corepack prepare pnpm@latest --activate
    else
      echo "corepack is not available. Please install pnpm manually: https://pnpm.io/installation"
      exit 1
    fi
  else
    echo "pnpm is already installed."
  fi

  if [ -f "package.json" ]; then
    echo "Running pnpm install..."
    pnpm install
  else
    echo "No package.json found. Skipping pnpm install."
  fi

  if ! pnpm list --depth=0 | grep -q git-cz; then
    echo "Installing git-cz as a dev dependency..."
    pnpm add -D git-cz
  else
    echo "git-cz is already present in devDependencies."
  fi

  echo "Installation complete!"
}

update() {
  echo "Running update..."
  # git pull
}

backup() {
  echo "Running backup..."
  # git add .
  # git commit -m "Backup on $(date)"
  # git push
}

link()  {
 	# find_links — lists symlinks and unlinked files separately (with optional color)

# --- Arguments ---
use_color=true
if [[ "${1:-}" == "--color=never" ]]; then
  use_color=false
fi

# --- Colors ---
RED='\033[1;31m'
RESET='\033[0m'
if ! $use_color; then
  RED=''
  RESET=''
fi

# --- Project directories ---
project_root="$(pwd)"
dir1="$project_root/src"
# dir2="$project_root/files-crypt"

# --- Temp file to store link targets ---
tempfile=$(mktemp)
trap 'rm -f "$tempfile"' EXIT

# --- Print symlinks ---
echo "=== LINKS TO FILES ==="

links(){
	set +e
	find "$HOME" -type l -print0 2>/dev/null | while IFS= read -r -d '' link; do
	  target=$(readlink -f "$link")
	  if [[ "$target" == "$dir1/"* ]]; then
	    if [[ -e "$target" ]]; then
	      printf '%s -> %s\n' "$link" "$target"
	      echo "$target" >> "$tempfile"
	    fi
	  fi
	done
	set -e
}

links

# --- Print unlinked files ---
echo -e "\n=== FILES WITHOUT LINKS ==="

sort -u "$tempfile" -o "$tempfile"

find "$dir1" -type f | while read -r file; do
  if ! grep -Fxq "$file" "$tempfile"; then
    printf '%b%s%b\n' "$RED" "$file" "$RESET"
  fi
done

}

[[ $# -eq 0 ]] && usage

case "$1" in
  install) install ;;
  update)  update ;;
  backup)  backup ;;
  link)    link ;;
  *)       usage ;;
esac
