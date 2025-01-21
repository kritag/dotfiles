#!/bin/env bash
/usr/bin/legcord &
while ! hyprctl clients | grep -q "Legcord"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,class:legcord
