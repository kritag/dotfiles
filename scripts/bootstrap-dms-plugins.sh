#!/usr/bin/env bash
# Install the DMS registry plugins given as ids (per-host list in the profile yaml); installed ones are skipped.
# Plugins aren't in dotfiles: the shared bar only draws a plugin widget where its plugin is installed.
for id; do
  [[ -d ~/.config/dms/plugins/$id ]] || dms plugins install "$id" || echo "dms plugins: $id not installed" >&2
done
