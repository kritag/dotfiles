#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
stamp="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-server-user"
trap 'mkdir -p "${stamp%/*}" && touch "$stamp"' EXIT

PYTHONDONTWRITEBYTECODE=1 dotbot -q -d "$repo" -c "$repo/server_user.conf.yaml"
