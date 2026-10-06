#!/bin/sh
set -eu

theme='Smoked-Glass-65'
archive=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/$theme.tar.gz
icons_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons"
target="$icons_dir/$theme"
legacy_dir="$HOME/.icons"
legacy_link="$legacy_dir/$theme"

if [ ! -f "$archive" ]; then
  echo "Cursor archive is missing: $archive" >&2
  exit 1
fi
if [ -e "$target" ] || [ -L "$target" ] || [ -e "$legacy_link" ] || [ -L "$legacy_link" ]; then
  echo "The theme already exists. Remove the existing copy before reinstalling." >&2
  exit 1
fi

mkdir -p "$icons_dir" "$legacy_dir"
tar -xzf "$archive" -C "$icons_dir"
ln -s "$target" "$legacy_link"
gsettings set org.gnome.desktop.interface cursor-theme "$theme"

echo "Installed and selected $theme. Fully restart apps that still show an older cursor."
