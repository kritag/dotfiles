#!/bin/bash
# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
#focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [[ "$lid_state" == "closed" ]]; then
  focused_monitor=$(hyprctl monitors | awk '/^Monitor/ {name=$2} /focused: yes/ && name != "e-DP1" {print name}')
  # Add logic for when the lid is closed
else
  focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

  # Add logic for when the lid is open
fi

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
  echo "Usage:
	$0 <dir containing images>"
  exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=simple

# This controls (in seconds) when to switch to the next image
INTERVAL=1800

while true; do
  find "$1" |
    while read -r img; do
      echo "$((RANDOM % 1000)):$img"
    done |
    sort -n | cut -d':' -f2- |
    while read -r img; do
      swww img -o $focused_monitor "$img"
      sleep $INTERVAL

    done
done
