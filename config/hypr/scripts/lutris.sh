#!/bin/env bash
/usr/bin/lutris &
while ! hyprctl clients | grep -q "lutris"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 2,class:net.lutris.Lutris
