#!/usr/bin/bash
#Try using this, you can also use it as daemon if you run it like './script daemon' (it will automatically execute whenever a monitor is connected). For single use just execute the script normally without any arguments.
#
#EDIT: I didn't bother to make it POSIX compatible. If that's something you want, then let me know.
#
#Dependencies:
#
#jq
#socat (optional: if you use 'daemon' argument)
main() {
  MONITORS=$(hyprctl monitors all -j)
  MONITOR_COUNT=$(jq 'length' <<<"$MONITORS")
  INTERNAL=$(jq '.[] | select(.name | startswith("eDP-"))' <<<"$MONITORS")
  INTERNAL_NAME=$(jq -r '.name' <<<$INTERNAL)
  INTERNAL_DISABLED=$(jq '.disabled' <<<"$INTERNAL")
  EXTERNALS=$(jq "map(select(.id!=$(jq '.id' <<<"$INTERNAL")))" <<<"$MONITORS")
  EXTERNAL_COUNT=$(jq 'length' <<<"$EXTERNALS")

  enable_internal() {
    hyprctl keyword monitor "$INTERNAL_NAME,enable" >/dev/null 2>&1
  }
  disable_internal() {
    hyprctl keyword monitor "$INTERNAL_NAME,disable" >/dev/null 2>&1
  }

  if [[ $EXTERNAL_COUNT > 0 ]]; then
    if [[ $INTERNAL_DISABLED = "false" ]]; then
      disable_internal
    fi
  else
    if [[ $INTERNAL_DISABLED = "true" ]]; then
      enable_internal
    fi
  fi
}

main

handle_hyprland_event() {
  case "$1" in
  monitor*)
    main
    ;;
  esac
}

for var in "$@"; do
  if [[ $var = "daemon" ]]; then
    socat -U - UNIX-CONNECT:/run/user/1000/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle_hyprland_event "$line"; done
    exit 1
  fi
done
