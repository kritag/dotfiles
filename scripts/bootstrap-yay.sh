#!/usr/bin/env bash
# Build yay from the AUR when missing: the yay profile plugin and the AUR package lists need it.
set -euo pipefail

command -v yay >/dev/null && exit 0

sudo pacman -S --needed --noconfirm git base-devel
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp"
cd "$tmp"
makepkg -si --noconfirm
