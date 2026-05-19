#!/bin/env bash
/usr/bin/legcord &
while ! hyprctl clients | grep -q "Legcord"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "3", follow = false, window = "class:legcord" })'
