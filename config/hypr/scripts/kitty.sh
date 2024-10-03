#!/bin/env bash
/usr/bin/kitty &
while ! hyprctl clients | grep -q "kitty"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 1,kitty
