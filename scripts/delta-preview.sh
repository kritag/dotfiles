#!/usr/bin/env bash
# Browse delta themes (bundled + dracula, catppuccin, tokyonight, rose-pine) with fzf, side-by-side,
# using a real commit as the sample diff.
# Usage: delta-preview.sh [dark|light] [commit]
set -euo pipefail

mode="${1:-dark}"
commit="${2:-HEAD~3}"
cache="${XDG_CACHE_HOME:-$HOME/.cache}"
extra="$cache/delta-extra"
bundled="$cache/delta-themes.gitconfig"
xdg_config="${XDG_CONFIG_HOME:-$HOME/.config}/git/config"

mkdir -p "$extra"
fetch() { [[ -f $2 ]] || curl -sLo "$2" "$1"; }

fetch https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig "$bundled"
fetch https://raw.githubusercontent.com/dracula/delta/main/dracula.gitconfig "$extra/dracula.gitconfig"
fetch https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig "$extra/catppuccin.gitconfig"
fetch https://raw.githubusercontent.com/rose-pine/delta/main/dist/rose-pine.gitconfig "$extra/rose-pine.gitconfig"
fetch https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/delta/tokyonight_night.gitconfig "$extra/tokyonight_night.raw"

# The tokyonight file sets a bare [delta] section; turn it into a named feature.
if [[ ! -f $extra/tokyonight-night.gitconfig ]]; then
  { printf '[delta "tokyonight-night"]\n\tdark = true\n'; tail -n +2 "$extra/tokyonight_night.raw"; } >"$extra/tokyonight-night.gitconfig"
fi

[[ -e $xdg_config ]] && { echo "$xdg_config already exists; move it aside first" >&2; exit 1; }

# delta ignores GIT_CONFIG_GLOBAL, so expose the themes through the XDG git config while previewing.
mkdir -p "$(dirname "$xdg_config")"
{
  printf '[include]\n'
  printf '\tpath = %s\n' "$bundled" "$extra"/dracula.gitconfig "$extra"/catppuccin.gitconfig \
    "$extra"/rose-pine.gitconfig "$extra"/tokyonight-night.gitconfig
} >"$xdg_config"
trap 'rm -f "$xdg_config"; rmdir "$(dirname "$xdg_config")" 2>/dev/null || true' EXIT

git config --name-only --get-regexp "^delta\..*\.$mode\$" | cut -d. -f2 | sort -u |
  fzf --preview "git show $commit --color=always | delta --features={} --side-by-side --paging=never --width=\$FZF_PREVIEW_COLUMNS" \
    --preview-window=right:75%
