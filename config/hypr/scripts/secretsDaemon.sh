#!/usr/bin/env bash
# D-Bus activation entry for org.freedesktop.secrets (see services/org.freedesktop.secrets.service).
# Starts the daemon already unlocked with the TPM-sealed password, so whichever client asks
# first can never activate a locked one. Falls back to the stock locked daemon if unsealing fails.
dir="$HOME/.config/keyring-tpm"
log="${XDG_STATE_HOME:-$HOME/.local/state}/unlockKeyring.log"
stock=(/usr/bin/gnome-keyring-daemon --start --foreground --components=secrets)
say() { echo "$(date +%T.%3N) activation: $*" >>"$log"; }

[[ -f $dir/seal.pub && -f $dir/seal.priv ]] || exec "${stock[@]}"

tmp=$(mktemp -d "$XDG_RUNTIME_DIR/unseal.XXXXXX") || exec "${stock[@]}"
trap 'rm -rf "$tmp"' EXIT

pw=$(
  tpm2_createprimary -C o -g sha256 -G ecc -c "$tmp/primary.ctx" >/dev/null 2>&1 &&
    tpm2_load -C "$tmp/primary.ctx" -u "$dir/seal.pub" -r "$dir/seal.priv" -c "$tmp/seal.ctx" >/dev/null 2>&1 &&
    tpm2_unseal -c "$tmp/seal.ctx" 2>/dev/null
)
rm -rf "$tmp"
trap - EXIT

[[ -n $pw ]] || {
  say "unseal failed, starting locked"
  exec "${stock[@]}"
}
say "starting unlocked"
# --start is incompatible with --unlock, so run the same daemon without it.
exec /usr/bin/gnome-keyring-daemon --foreground --components=secrets --unlock < <(printf %s "$pw")
