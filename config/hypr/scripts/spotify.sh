#!/bin/env bash
/usr/bin/spotify-launcher &
while ! hyprctl clients | grep -q "Spotify"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 4,Spotify
