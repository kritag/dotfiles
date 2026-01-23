#!/usr/bin/env bash
set -euo pipefail

themes=(
  "tokyonight|Tokyo-Night-GTK-Theme|A GTK theme based on the Tokyo Night colour palette."
  "catppuccin|Catppuccin-GTK-Theme|A GTK theme based on the Catppuccin colour palette."
  "everforest|Everforest-GTK-Theme|A GTK theme based on the Everforest colour palette."
  "gruvbox|Gruvbox-GTK-Theme|A GTK theme based on the Gruvbox colour palette."
  "rose-pine|Rose-Pine-GTK-Theme|A GTK theme based on the Rosé Pine colour palette."
)

for entry in "${themes[@]}"; do
  IFS='|' read -r name repo desc <<<"$entry"

  dir="${name}-gtk-theme-git"
  mkdir -p "$dir"

  sed \
    -e "s|@PKGNAME@|${name}-gtk-theme-git|g" \
    -e "s|@REPONAME@|${repo}|g" \
    -e "s|@PKGDESC@|${desc}|g" \
    PKGBUILD.template >"$dir/PKGBUILD"

  echo "generated $dir/PKGBUILD"
done
