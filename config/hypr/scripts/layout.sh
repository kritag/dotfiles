#!/usr/bin/env bash
# Hyprland layout for the DMS "Dank Actions" widget and the layout keybinds.
#   layout.sh              print the current layout
#   layout.sh cycle        switch to the next one
#   layout.sh set <name>   switch to <name> (dwindle, lua:grid, lua:manual, lua:columns)
# The choice is saved so general.lua restores it on reload and restart.
layouts=(dwindle lua:grid lua:manual lua:columns)
state=${XDG_STATE_HOME:-$HOME/.local/state}/hypr-layout
current=$(hyprctl getoption general:layout -j | jq -r .str)

apply() {
    mkdir -p "$(dirname "$state")"
    echo "$1" >"$state"
    hyprctl eval "hl.config({ general = { layout = \"$1\" } }); grid_mouse_sync()" >/dev/null
}

case ${1:-} in
cycle)
    for i in "${!layouts[@]}"; do
        [[ ${layouts[i]} == "$current" ]] && next=${layouts[(i + 1) % ${#layouts[@]}]}
    done
    apply "${next:-dwindle}"
    ;;
set) apply "$2" ;;
*) echo "${current#lua:}" ;;
esac
