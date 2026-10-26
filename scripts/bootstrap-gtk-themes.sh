#!/usr/bin/env bash
set -euo pipefail

name=Everforest-Dark-Compact
dest=${XDG_DATA_HOME:-$HOME/.local/share}/themes

for d in "$dest" "$HOME/.themes" /usr/share/themes; do
  [[ -f $d/$name/gtk-4.0/gtk.css ]] && exit 0
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme "$tmp/src"
mkdir -p "$dest"
"$tmp/src/themes/install.sh" --dest "$dest" --size compact --color dark >/dev/null
