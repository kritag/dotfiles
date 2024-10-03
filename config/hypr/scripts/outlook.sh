#!/bin/env bash
/opt/microsoft/msedge/microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn --app-url=https://outlook.office.com/mail/ &
while ! hyprctl clients | grep -q "msedge-_faolnafnngnfdaknnbpnkhgohbobgegn-Default"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 3,msedge-_faolnafnngnfdaknnbpnkhgohbobgegn-Default
