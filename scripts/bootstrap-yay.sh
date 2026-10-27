#!/usr/bin/env bash
# Build yay from the AUR when missing: the yay profile plugin and the AUR package lists need it.
set -euo pipefail

command -v yay >/dev/null && exit 0

# CachyOS ships yay in its repo; on Arch it is not there and the AUR build below runs.
if pacman -Si yay >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm yay
  exit 0
fi

sudo pacman -S --needed --noconfirm git base-devel
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp"
cd "$tmp"
makepkg -si --noconfirm
