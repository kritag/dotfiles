#!/bin/env bash
/usr/bin/steam &
while ! hyprctl clients | grep -q "steam"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 2,class:steam
