#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Error: run as root (for example via sudo)." >&2
  exit 1
fi

if [[ -z "${SUDO_USER:-}" ]]; then
  echo "Error: SUDO_USER is not set. Run this script through sudo." >&2
  exit 1
fi

dropin_dir="/etc/sudoers.d"
dropin_file="${dropin_dir}/90-${SUDO_USER}-nopasswd"
entry="${SUDO_USER} ALL=(ALL) NOPASSWD: ALL"

mkdir -p "${dropin_dir}"
tmp_file="$(mktemp)"
trap 'rm -f "${tmp_file}"' EXIT

printf '%s\n' "${entry}" > "${tmp_file}"
chmod 0440 "${tmp_file}"

# Validate sudoers syntax before installing.
visudo -cf "${tmp_file}" >/dev/null

install -m 0440 "${tmp_file}" "${dropin_file}"
echo "Installed ${dropin_file}"
