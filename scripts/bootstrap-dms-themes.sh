#!/usr/bin/env bash
# Install the DMS registry themes themeSwitch.sh switches between, laid out like DMS's theme browser does:
# registry themes/<dir>/ saved as ~/.config/dms/themes/<theme id>/ (theme.json + preview SVGs).
# Plain downloads, so it works before DMS has ever run; installed themes are skipped.
repo=duxlabs-dev/dux-plugin-registry
raw=https://raw.githubusercontent.com/$repo/master/themes

for dir in catppuccin dracula everforest gruvbox-material nord rose-pine tokyonight; do
  json="$(curl -fsSL "$raw/$dir/theme.json")" || { echo "dms themes: $dir not downloaded" >&2; continue; }
  dest=~/.config/dms/themes/$(jq -r .id <<<"$json")
  [[ -f $dest/theme.json ]] && continue
  mkdir -p "$dest" && printf '%s\n' "$json" >"$dest/theme.json"
  curl -fsSL "https://api.github.com/repos/$repo/contents/themes/$dir" | jq -r '.[].name | select(endswith(".svg"))' |
    while read -r svg; do curl -fsSL -o "$dest/$svg" "$raw/$dir/$svg"; done
done
