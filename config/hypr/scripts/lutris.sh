#!/bin/env bash
/usr/bin/lutris &
while ! hyprctl clients | grep -q "lutris"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "2", follow = false, window = "class:net.lutris.Lutris" })'
