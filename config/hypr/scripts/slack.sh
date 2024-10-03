#!/bin/env bash
/usr/bin/slack &
while ! hyprctl clients | grep -q "Slack"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 2,Slack
