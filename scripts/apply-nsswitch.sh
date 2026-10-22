#!/usr/bin/env bash
# Replace the hosts: line of /etc/nsswitch.conf with the one in config/nsswitch.conf. Run as root.
set -euo pipefail

src="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../config/nsswitch.conf"
dst=/etc/nsswitch.conf

want=$(grep -E '^hosts:[[:space:]]' "$src") || { echo "no hosts: line in $src" >&2; exit 1; }
have=$(grep -E '^hosts:[[:space:]]' "$dst" || true)
[[ $have == "$want" ]] && exit 0

# authselect regenerates nsswitch.conf, so stop it managing the file or it reverts the edit.
if command -v authselect >/dev/null && authselect current >/dev/null 2>&1; then
  echo "nsswitch: authselect manages $dst, opting out"
  authselect opt-out
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
WANT=$want awk '
  /^hosts:[[:space:]]/ { if (!done) print ENVIRON["WANT"]; done = 1; next }
  { print }
  END { if (!done) print ENVIRON["WANT"] }
' "$dst" >"$tmp"
install -m 0644 "$tmp" "$dst"
echo "nsswitch: set $want"
