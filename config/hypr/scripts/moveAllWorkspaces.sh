#!/bin/bash

# JSON output: the text format of `hyprctl workspaces` changed in 0.57 ("workspace ID 1" -> "workspace 1")
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .id')

# Move each workspace to the active monitor (special workspaces have negative ids)
for workspace in $(hyprctl workspaces -j | jq -r '.[] | select(.id > 0) | .id'); do
  hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$workspace\", monitor = \"$ACTIVE_MONITOR\" })"
done
