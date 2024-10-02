#!/bin/bash

# Get the active monitor ID by searching for the "Monitor" line directly above the "focused: yes" line
ACTIVE_MONITOR=$(hyprctl monitors | awk '/Monitor/ {id=$4} /focused: yes/ {print id}' | tr -d '():')

# Move each workspace to the active monitor
for workspace in $(hyprctl workspaces | grep -Eo 'ID [0-9]+' | awk '{print $2}'); do
  hyprctl dispatch moveworkspacetomonitor "$workspace" "$ACTIVE_MONITOR"
done
