#!/bin/env bash
/usr/lib/firefox/firefox &
while ! hyprctl clients | grep -q "Firefox"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 1,firefox
