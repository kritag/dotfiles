#!/bin/env bash
/usr/bin/kitty &
while ! hyprctl clients | grep -q "kitty"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "1", follow = false, window = "kitty" })'
