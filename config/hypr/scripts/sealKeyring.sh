#!/usr/bin/env bash
# Seal the keyring password to this machine's TPM. Run once (and after any keyring password change).
set -euo pipefail
dir="$HOME/.config/keyring-tpm"
mkdir -p "$dir"; chmod 700 "$dir"
tmp=$(mktemp -d "$XDG_RUNTIME_DIR/seal.XXXXXX"); trap 'rm -rf "$tmp"' EXIT

read -rsp "Keyring password: " pw; echo
tpm2_createprimary -C o -g sha256 -G ecc -c "$tmp/primary.ctx" >/dev/null
printf %s "$pw" | tpm2_create -C "$tmp/primary.ctx" -i- -u "$dir/seal.pub" -r "$dir/seal.priv" >/dev/null
chmod 600 "$dir"/seal.*
echo "Sealed to $dir"
