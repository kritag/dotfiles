#!/bin/sh
hyprctl clients | awk '/title: ./ { gsub("\t*title: *", ""); print}' | rofi -show window -window-title "Windows" | xargs -I{} hyprctl dispatch focuswindow "title:{}"
