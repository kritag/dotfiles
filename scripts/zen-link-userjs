#!/usr/bin/env bash
set -euo pipefail

ZEN_BASE="${ZEN_BASE:-$HOME/.config/zen}"
SOURCE_USERJS="${SOURCE_USERJS:-$HOME/.dotfiles/config/zen/user.js}"

detect_profile_rel() {
  local installs_ini="$ZEN_BASE/installs.ini"
  local profiles_ini="$ZEN_BASE/profiles.ini"
  local rel=""

  if [[ -f "$installs_ini" ]]; then
    rel="$(awk -F= '$1=="Default"{print $2; exit}' "$installs_ini")"
    if [[ -n "$rel" && -d "$ZEN_BASE/$rel" ]]; then
      printf '%s\n' "$rel"
      return
    fi
  fi

  if [[ -f "$profiles_ini" ]]; then
    rel="$(awk -F= '/^\[Profile[0-9]+\]/{in_profile=1; next} in_profile&&$1=="Path"{print $2; exit}' "$profiles_ini")"
    if [[ -n "$rel" && -d "$ZEN_BASE/$rel" ]]; then
      printf '%s\n' "$rel"
      return
    fi
  fi

  return 1
}

if [[ ! -d "$ZEN_BASE" ]]; then
  echo "Zen config directory not found at $ZEN_BASE; skipping user.js link."
  exit 0
fi

if [[ ! -f "$SOURCE_USERJS" ]]; then
  echo "Source user.js not found at $SOURCE_USERJS" >&2
  exit 1
fi

if ! rel_profile="$(detect_profile_rel)"; then
  echo "Could not detect Zen profile under $ZEN_BASE; skipping user.js link."
  exit 0
fi

profile_dir="$ZEN_BASE/$rel_profile"
target_userjs="$profile_dir/user.js"

mkdir -p "$profile_dir"
ln -sfn "$SOURCE_USERJS" "$target_userjs"

echo "Linked $target_userjs -> $SOURCE_USERJS"
