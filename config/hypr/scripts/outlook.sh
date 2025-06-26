#!/bin/env bash
/opt/Prospect\ Mail/prospect-mail &
while ! hyprctl clients | grep -q "Outlook for Linux"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,Prospect
