#!/bin/env bash
/usr/lib/firefox/firefox &
while ! hyprctl clients | grep -q "Firefox"; do
  sleep 0.2
done
hyprctl dispatch 'hl.dsp.window.move({ workspace = "1", follow = false, window = "firefox" })'
