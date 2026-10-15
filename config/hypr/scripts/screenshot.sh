#!/usr/bin/env sh
# Screenshot on a black background with square corners.
#   screenshot.sh area|screen|active <output path>
# `area` lets you click a window or drag a region. Everything is put back from the
# values read before the capture, so nothing here has to match decoration.lua.
set -eu

mode="${1:-area}" # area|screen|active
out="${2:?output path required}"

BLACK="$(dirname "$(readlink -f "$0")")/../../../solid_background/black.png"

opt() { hyprctl getoption "$1" -j | jq -r ".$2"; }

# general.* (gaps/border) deliberately left alone: changing them triggers a
# layout recalc, which in `columns` visibly reshuffles windows.
anim=$(opt animations:enabled bool)
shadow=$(opt decoration:shadow:enabled bool)
blur=$(opt decoration:blur:enabled bool)
rounding=$(opt decoration:rounding int)
wallpaper=$(dms ipc call wallpaper get 2>/dev/null || true)

restore() {
  [ -n "$wallpaper" ] && dms ipc call wallpaper set "$wallpaper" >/dev/null 2>&1
  hyprctl eval "hl.config({
    animations = { enabled = $anim },
    decoration = { shadow = { enabled = $shadow }, blur = { enabled = $blur }, rounding = $rounding },
  })" >/dev/null 2>&1 || true
}
trap restore EXIT INT TERM

hyprctl eval 'hl.config({
  animations = { enabled = false },
  decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
})' >/dev/null
dms ipc call wallpaper set "$BLACK" >/dev/null
sleep 0.12
grimblast copysave "$mode" "$out"
