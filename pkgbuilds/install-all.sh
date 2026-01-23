#!/usr/bin/env bash
set -e

PKGROOT="$HOME/.dotfiles/pkgbuilds"

if [[ ! -d "$PKGROOT" ]]; then
  echo "error: $PKGROOT not found"
  exit 1
fi

mkpkg() {
  local dir="$1"
  local tmp

  tmp="$(mktemp -d)"

  echo "==> Building $(basename "$dir")"

  cp "$dir/PKGBUILD" "$tmp"

  (
    cd "$tmp"
    makepkg -si --noconfirm --needed
  )

  rm -rf "$tmp"
}

for dir in "$PKGROOT"/*; do
  [[ -d "$dir" ]] || continue
  [[ -f "$dir/PKGBUILD" ]] || continue

  mkpkg "$dir"
done
