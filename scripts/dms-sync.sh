#!/usr/bin/env bash
# Copy one host's DMS settings onto the other's, keeping the target's host-only keys.
# Shows the change with delta and asks first. Usage: dms-sync.sh desktop workstation
host_keys='["greeterAutoLogin"]'
dir=$(dirname "$(realpath "$0")")/../config/dms
from=$dir/settings-$1.json to=$dir/settings-$2.json
[[ $# -eq 2 && $1 != "$2" && -f $from && -f $to ]] || { echo "usage: ${0##*/} <from> <to>  (desktop|workstation)" >&2; exit 1; }

new=$(jq --slurpfile t "$to" --argjson k "$host_keys" \
  'del(.[$k[]]) + ($t[0] | with_entries(select(.key | IN($k[]))))' "$from") || exit 1
if command diff -q <(jq -S . "$to") <(jq -S . <<<"$new") >/dev/null; then echo "in sync"; exit; fi

command diff -u --label "settings-$2.json" --label "settings-$2.json (from $1)" <(jq -S . "$to") <(jq -S . <<<"$new") |
  delta --paging=never
read -rp "Apply to settings-$2.json? [y/N] " a
[[ $a == y ]] && printf '%s\n' "$new" >"$to"
