#!/bin/env bash
/usr/bin/firefox %u &
while ! hyprctl clients | grep -q "Firefox"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 1,firefox
