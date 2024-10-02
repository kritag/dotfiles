#!/bin/sh
hyprctl clients | awk '/title: ./ { gsub("\t*title: *", ""); print}' | rofi -dmenu -window-title "Windows" | xargs -I{} hyprctl dispatch focuswindow "title:{}"
