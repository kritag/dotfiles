#!/usr/bin/env bash
set -e

PKGROOT="$HOME/.dotfiles/pkgbuilds"

for dir in "$PKGROOT"/*; do
  [[ -d "$dir" ]] || continue
  [[ -f "$dir/PKGBUILD" ]] || continue

  echo "==> Installing $(basename "$dir")"

  (
    cd "$dir"
    makepkg -si --noconfirm --needed
  )
done
