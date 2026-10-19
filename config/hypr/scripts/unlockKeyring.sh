#!/usr/bin/env bash
# Unlock the login keyring after a fingerprint or key login using a TPM-sealed password.
# Seal once with: ~/.config/hypr/scripts/sealKeyring.sh
dir="$HOME/.config/keyring-tpm"
[[ -f $dir/seal.pub && -f $dir/seal.priv ]] || exit 0

log="${XDG_STATE_HOME:-$HOME/.local/state}/unlockKeyring.log"
mkdir -p "${log%/*}"
say() { echo "$(date +%T.%3N) $*" >> "$log"; }
locked_state() {
  busctl --user get-property org.freedesktop.secrets \
    /org/freedesktop/secrets/collection/login \
    org.freedesktop.Secret.Collection Locked 2>&1
}

export GNOME_KEYRING_CONTROL="${GNOME_KEYRING_CONTROL:-$XDG_RUNTIME_DIR/keyring}"

say "start: $(locked_state)"
[[ $(locked_state) == "b false" ]] && { say "already unlocked"; exit 0; }

tmp=$(mktemp -d "$XDG_RUNTIME_DIR/unseal.XXXXXX"); trap 'rm -rf "$tmp"' EXIT

# Fail before touching the daemon: an empty password makes --unlock pop a prompt.
tpm2_createprimary -C o -g sha256 -G ecc -c "$tmp/primary.ctx" >/dev/null 2>&1 || { say "createprimary failed"; exit 1; }
tpm2_load -C "$tmp/primary.ctx" -u "$dir/seal.pub" -r "$dir/seal.priv" -c "$tmp/seal.ctx" >/dev/null 2>&1 || { say "load failed"; exit 1; }
pw=$(tpm2_unseal -c "$tmp/seal.ctx" 2>/dev/null) || { say "unseal failed"; exit 1; }
[[ -n $pw ]] || { say "empty password"; exit 1; }

printf %s "$pw" | gnome-keyring-daemon --replace --daemonize --unlock >/dev/null
rc=$?

# --daemonize returns before the daemon owns org.freedesktop.secrets. A client asking in
# that gap makes D-Bus activate a second, locked daemon that takes over. Wait (max 5s,
# normally well under a second) until the owner is the daemon we just unlocked.
secrets_owner_unlocked() {
  local pid
  pid=$(busctl --user status org.freedesktop.secrets 2>/dev/null | sed -n 's/^PID=//p')
  [[ -n $pid && $(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null) == *--unlock* ]]
}
for _ in $(seq 100); do
  secrets_owner_unlocked && [[ $(locked_state) == "b false" ]] && break
  sleep 0.05
done
say "unlock exit=$rc took=${SECONDS}s now: $(locked_state)"
