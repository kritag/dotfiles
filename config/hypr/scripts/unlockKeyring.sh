#!/usr/bin/env bash
# Unlock the login keyring after a fingerprint or key login using a TPM-sealed password.
# Seal once with: ~/.config/hypr/scripts/sealKeyring.sh
dir="$HOME/.config/keyring-tpm"
[[ -f $dir/seal.pub && -f $dir/seal.priv ]] || exit 0

export GNOME_KEYRING_CONTROL="${GNOME_KEYRING_CONTROL:-$XDG_RUNTIME_DIR/keyring}"

locked=$(busctl --user get-property org.freedesktop.secrets \
  /org/freedesktop/secrets/collection/login \
  org.freedesktop.Secret.Collection Locked 2>/dev/null)
[[ $locked == "b false" ]] && exit 0

tmp=$(mktemp -d "$XDG_RUNTIME_DIR/unseal.XXXXXX"); trap 'rm -rf "$tmp"' EXIT

# Fail before touching the daemon: an empty password makes --unlock pop a prompt.
tpm2_createprimary -C o -g sha256 -G ecc -c "$tmp/primary.ctx" >/dev/null 2>&1 || exit 1
tpm2_load -C "$tmp/primary.ctx" -u "$dir/seal.pub" -r "$dir/seal.priv" -c "$tmp/seal.ctx" >/dev/null 2>&1 || exit 1
pw=$(tpm2_unseal -c "$tmp/seal.ctx" 2>/dev/null) || exit 1
[[ -n $pw ]] || exit 1
printf %s "$pw" | gnome-keyring-daemon --replace --daemonize --unlock >/dev/null
