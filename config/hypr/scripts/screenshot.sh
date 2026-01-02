!/usr/bin/env sh
set -eu

mode="${1:-area}" # area|screen|active
out="${2:?output path required}"

BLACK="$HOME/.dotfiles/solid_background/black.png"
NORMAL="$HOME/.dotfiles/wallpapers/5xcb4pqt1vj61.jpg"

restore() {
  # restore wallpaper first
  dms ipc call wallpaper set "$NORMAL" >/dev/null 2>&1 || true

  # restore the basics we toggled (so you don't stay in screenshot-mode even briefly)
  hyprctl --batch "\
    keyword animations:enabled 1; \
    keyword decoration:shadow:enabled 1; \
    keyword decoration:blur:enabled 1; \
    keyword general:gaps_in 0; \
    keyword general:gaps_out 0; \
    keyword general:border_size 1; \
    keyword decoration:rounding 12" >/dev/null 2>&1 || true

  # IMPORTANT: re-apply your *entire* config (restores blur/shadow params, gaps, etc.)
  hyprctl reload >/dev/null 2>&1 || true
}
trap restore EXIT INT TERM

# Screenshot-mode (flat + fast)
hyprctl --batch "\
  keyword animations:enabled 0; \
  keyword decoration:shadow:enabled 0; \
  keyword decoration:blur:enabled 0; \
  keyword general:gaps_in 0; \
  keyword general:gaps_out 0; \
  keyword general:border_size 1; \
  keyword decoration:rounding 0" >/dev/null

# Black wallpaper so transparency becomes black
dms ipc call wallpaper set "$BLACK" >/dev/null
sleep 0.12

# Screenshot
grimblast copysave "$mode" "$out"
