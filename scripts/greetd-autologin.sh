#!/usr/bin/env bash
# A `dms-greeter sync` rewrites [initial_session] from that (false) setting; rerun this afterwards.
config=${1:-/etc/greetd/config.toml}
user=${SUDO_USER:-$USER}

awk -v user="$user" '
  /^\[/ { skip = ($0 == "[initial_session]") }
  !skip
  END { print "\n[initial_session]\nuser = \"" user "\"\ncommand = \"uwsm start hyprland-uwsm.desktop\"" }
' "$config" | cat -s >"$config.tmp" && mv "$config.tmp" "$config"
