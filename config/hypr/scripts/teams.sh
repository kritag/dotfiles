#!/bin/env bash
/usr/bin/teams-for-linux &
while ! hyprctl clients | grep -q "teams-for-linux"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,teams-for-linux
