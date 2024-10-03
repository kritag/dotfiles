#!/bin/sh
displayConnected=$(xrandr | awk '/ connected/ {count++} END {print count}')
if [ "$displayConnected" -gt 1 ]; then
  hyprctl keyword monitor "eDP-1, disable"
fi
