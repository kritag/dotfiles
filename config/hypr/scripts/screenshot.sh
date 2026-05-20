#!/usr/bin/env sh
set -eu

mode="${1:-area}" # area|screen|active
out="${2:?output path required}"

BLACK="$HOME/.dotfiles/solid_background/black.png"
NORMAL="$HOME/.dotfiles/wallpapers/5xcb4pqt1vj61.jpg"

# Live config patches via lua eval. Values mirror general.lua / decoration.lua —
# keep in sync if those change. Avoids `hyprctl reload`, which re-evaluates the
# whole config and causes layout recalcs (visible window reshuffle).

-- general.* (gaps/border) deliberately omitted: changing them triggers a
-- layout recalc, which in `columns` visibly reshuffles windows.
SCREENSHOT_MODE='hl.config({
  animations = { enabled = false },
  decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
})'

RESTORE='hl.config({
  animations = { enabled = true },
  decoration = { shadow = { enabled = true },  blur = { enabled = true },  rounding = 12 },
})'

restore() {
  dms ipc call wallpaper set "$NORMAL" >/dev/null 2>&1 || true
  hyprctl eval "$RESTORE" >/dev/null 2>&1 || true
}
trap restore EXIT INT TERM

hyprctl eval "$SCREENSHOT_MODE" >/dev/null
dms ipc call wallpaper set "$BLACK" >/dev/null
sleep 0.12
grimblast copysave "$mode" "$out"
