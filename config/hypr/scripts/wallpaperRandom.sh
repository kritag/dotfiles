#!/bin/bash

WALLDIR=~/.dotfiles/wallpapers
PICS=($(\ls ${WALLDIR}))
RANDOMPICS=${PICS[$RANDOM % ${#PICS[@]}]}

OUTPUT_LIST=""
for OUTPUT in $(hyprctl monitors all | grep "Monitor" | awk '{print $2}'); do
  OUTPUT_LIST+="$OUTPUT,"
done

# Remove trailing comma
OUTPUT_LIST="${OUTPUT_LIST%,}"
echo $OUTPUT_LIST

#change-wallpaper using swww
swww img ${WALLDIR}/${RANDOMPICS} --outputs="$OUTPUT_LIST" --transition-fps 60 --transition-type any --transition-duration 2

# wal -i ~/.config/rofi/.current_wallpaper

~/.config/hypr/scripts/pywalCurrentWallpaper.sh

sleep 1
swaync-client -rs &
swaync-client -R
