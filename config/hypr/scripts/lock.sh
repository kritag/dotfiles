#!/bin/env bash
wallpaper=$(swww query | grep DP | awk '{print $8}')
# Step 2: Define the Hyprlock config file path
config_file="$HOME/.config/hypr/hyprlock.conf"

# Step 3: Use sed to update the wallpaper path in the config file
sed -i "s|path = .*|path = $wallpaper|g" "$config_file"

# Step 4: Run Hyprlock with the updated config
gtklock -d -c ~/.config/gtklock/config.ini -s ~/.config/gtklock/styles.css
