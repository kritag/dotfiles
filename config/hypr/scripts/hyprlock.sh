#!/bin/env bash
wallpaper=$(swww query | grep DP | grep --invert-match eDP | awk '{print $8}')
# Step 2: Define the Hyprlock config file path
config_file="$HOME/.config/hypr/hyprlock.conf" # Adjust to your config path

# Step 3: Use sed to update the wallpaper path in the config file
sed -i "s|path = .*|path = $wallpaper|g" "$config_file"

# Step 4: Run Hyprlock with the updated config
hyprlock
