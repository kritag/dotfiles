#!/bin/env bash
/opt/outlook-for-linux/outlook-for-linux --ozone-platform-hint=auto &
while ! hyprctl clients | grep -q "Outlook for Linux"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,outlook-for-linux
