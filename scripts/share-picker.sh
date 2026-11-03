#!/usr/bin/env bash
# xdph screen-share picker. GTK loads ~/.config/gtk-4.0/gtk.css (the Everforest theme)
# above the picker's own stylesheet, so its .card/window/tab rules win and the picker's
# styling (hover highlight included) is lost. An empty XDG_CONFIG_HOME skips that file.
set -euo pipefail

empty="${XDG_RUNTIME_DIR:-/tmp}/share-picker-config"
mkdir -p "$empty"

XDG_CONFIG_HOME="$empty" exec hyprland-preview-share-picker \
  -c "$HOME/.config/hyprland-preview-share-picker/config.yaml" "$@"
