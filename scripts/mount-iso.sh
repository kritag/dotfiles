#!/usr/bin/env bash
# Attach disk images read-only and mount their filesystems through udisks (no root).
# Autoclear frees the loop device on unmount, so the file manager's Unmount fully detaches.
set -euo pipefail

# Repeated double-clicks/Enter start several runs at once; queue them so the reuse check sees earlier ones
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/mount-iso.lock"
flock 9

for img in "$@"; do
  img="${img#file://}"
  # Reuse a loop device already backed by this image instead of attaching it twice
  dev=$(losetup -nO NAME -j "$img" | sed -n 1p)
  if [[ -z "$dev" ]]; then
    out=$(udisksctl loop-setup --read-only --no-user-interaction -f "$img")
    dev=$(sed -n 's/.* as \(\/dev\/loop[0-9]*\)\.$/\1/p' <<<"$out")
    [[ -n "$dev" ]] || { echo "Error: no loop device in: $out" >&2; exit 1; }
  fi

  udevadm settle
  # Mount what udisks offers as a filesystem and doesn't hint to ignore, like an automounter would
  # (a hybrid ISO mounts its main partition and skips the EFI one)
  while read -r blk; do
    info=$(udisksctl info -b "$blk")
    rg -q 'org.freedesktop.UDisks2.Filesystem:' <<<"$info" || continue
    rg -q 'HintIgnore:\s+true' <<<"$info" && continue
    [[ -n "$(lsblk -nro MOUNTPOINTS "$blk")" ]] && continue
    udisksctl mount --no-user-interaction -b "$blk" || true
  done < <(lsblk -nrpo NAME "$dev")

  # Only after mounting: autoclear on an unopened loop device frees it at once
  gdbus call --system --dest org.freedesktop.UDisks2 \
    --object-path "/org/freedesktop/UDisks2/block_devices/${dev#/dev/}" \
    --method org.freedesktop.UDisks2.Loop.SetAutoclear true '{}' >/dev/null
done
