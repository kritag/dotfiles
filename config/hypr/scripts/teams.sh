#!/bin/env bash
/opt/microsoft/msedge/microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo --app-url=https://teams.microsoft.com/v2/?clientType=pwa &
while ! hyprctl clients | grep -q "msedge-_cifhbcnohmdccbgoicgdjpfamggdegmo-Default"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,msedge-_cifhbcnohmdccbgoicgdjpfamggdegmo-Default
