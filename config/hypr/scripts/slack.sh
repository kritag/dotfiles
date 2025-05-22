#!/bin/env bash
/usr/bin/slack --disable-gpu-compositing --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --enable-features=WebRTCPipeWireCapturer --enable-features=WaylandWindowDecorations -s %U &
while ! hyprctl clients | grep -q "Slack"; do
  sleep 0.2
done
hyprctl dispatch movetoworkspacesilent 2,Slack
