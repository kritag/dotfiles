#!/bin/bash

# WALLPAPERS PATH
WALLDIR="$HOME/.dotfiles/wallpapers"

# Transition config
FPS=60
TYPE="wipe"
DURATION=2
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Retrieve image files
PICS=($(ls "${WALLDIR}" | \grep -E ".jpg$|.jpeg$|.png$|.gif$"))
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Rofi command
ROFI_COMMAND="rofi -show -dmenu -theme $HOME/.config/rofi/themes/wallpaper-select.rasi"

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${WALLDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done

  printf "$RANDOM_PIC_NAME\n"
}

# swww query || swww init

main() {
  CHOICE=$(menu | ${ROFI_COMMAND})

  # No CHOICE case
  if [[ -z $CHOICE ]]; then
    exit 0
  fi

  # Random CHOICE case
  if [ "$CHOICE" = "$RANDOM_PIC_NAME" ]; then
    swww --clear-cache
    swww img "${WALLDIR}/${RANDOM_PIC}" $SWWW_PARAMS
    exit 0
  fi

  # Find the index of the selected file
  PIC_INDEX=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$CHOICE"* ]]; then
      PIC_INDEX=$i
      break
    fi
  done

  if [[ $PIC_INDEX -ne -1 ]]; then
    swww --clear-cache
    swww img "${WALLDIR}/${PICS[$PIC_INDEX]}" $SWWW_PARAMS
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
  exit 0
fi

main

# wal -i ~/.config/rofi/.current_wallpaper

~/.config/hypr/scripts/pywalCurrentWallpaper.sh

sleep 1
swaync-client -rs &
swaync-client -R

# pywal-discord
