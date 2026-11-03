#!/usr/bin/env bash
# Pull the latest ModernZ release into the repo: scripts and icon font are replaced as-is,
# each upstream .conf is kept as a baseline next to the tinty template that generates ours.
# The printed baseline diffs are what to carry into those templates by hand.
set -euo pipefail

repo="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
mpv="$repo/config/mpv"
tinty="$repo/config/tinty/templates"

current=$(sed -nE '1s/^-- ModernZ (v[^ ]+).*/\1/p' "$mpv/scripts/modernz.lua")
latest=$(gh release view -R Samillion/ModernZ --json tagName -q .tagName)
if [[ "$current" == "$latest" && -f "$mpv/scripts/pause_indicator_lite.lua" ]]; then
  echo "ModernZ already at $current"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
gh release download "$latest" -R Samillion/ModernZ -D "$tmp" -p modernz.lua -p modernz-icons.ttf -p modernz.conf
# Extras aren't release assets; take them from the same tag
for f in pause_indicator_lite.lua pause_indicator_lite.conf; do
  gh api "repos/Samillion/ModernZ/contents/extras/pause-indicator-lite/$f?ref=$latest" \
    -H "Accept: application/vnd.github.raw" >"$tmp/$f"
done

# Upstream ships CRLF; strip it so themed edits and diffs stay clean
sed -i 's/\r$//' "$tmp"/*.lua "$tmp"/*.conf
install -m644 "$tmp/modernz.lua" "$tmp/pause_indicator_lite.lua" "$mpv/scripts/"
install -m644 "$tmp/modernz-icons.ttf" "$mpv/fonts/"

echo "ModernZ $current -> $latest"
# conf -> tinty template dir holding its upstream.conf baseline
for pair in modernz.conf:mpv pause_indicator_lite.conf:mpv-pause-indicator; do
  conf=${pair%%:*} baseline="$tinty/${pair#*:}/upstream.conf"
  echo "Upstream $conf changes (merge into ${baseline%/*}/templates/default.mustache):"
  diff -u "$baseline" "$tmp/$conf" || true
  install -m644 "$tmp/$conf" "$baseline"
done
