#!/usr/bin/env bash
# Hyprland layout for the DMS "Dank Actions" widget.
#   layout.sh        print the current layout
#   layout.sh cycle  switch to the next one
layouts=(dwindle lua:grid lua:manual lua:columns)
current=$(hyprctl getoption general:layout -j | jq -r .str)

if [[ ${1:-} == cycle ]]; then
    for i in "${!layouts[@]}"; do
        [[ ${layouts[i]} == "$current" ]] && next=${layouts[(i + 1) % ${#layouts[@]}]}
    done
    hyprctl eval "hl.config({ general = { layout = \"${next:-dwindle}\" } })" >/dev/null
    exit
fi

echo "${current#lua:}"
