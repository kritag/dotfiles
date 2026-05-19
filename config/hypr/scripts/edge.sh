#!/bin/env bash
/usr/bin/microsoft-edge-stable --enable-features=UseOzonePlatform --ozone-platform=wayland &
while ! hyprctl clients | grep -q "microsoft-edge"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "2", follow = false, window = "microsoft-edge" })'
