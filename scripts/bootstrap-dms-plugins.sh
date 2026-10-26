#!/usr/bin/env bash
for id; do
  [[ -d ~/.config/dms/plugins/$id ]] || dms plugins install "$id" || echo "dms plugins: $id not installed" >&2
done
