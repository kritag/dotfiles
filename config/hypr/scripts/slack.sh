#!/bin/env bash
/usr/bin/slack -s --enable-features=UseOzonePlatform --ozone-platform=wayland --force-device-scale-factor %U &
while ! hyprctl clients | grep -q "Slack"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 2,Slack
