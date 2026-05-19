#!/bin/env bash
/usr/bin/steam &
while ! hyprctl clients | grep -q "steam"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "2", follow = false, window = "class:steam" })'
