#!/usr/bin/env bash
# Link the shared tool configs (server_user.conf.yaml) into $HOME for the current user.
# zsh/server-global.zsh runs this on a user's first shell and again whenever that file changes.
set -euo pipefail

repo="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
stamp="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-server-user"
# touch even on failure so a broken home does not retry on every shell
trap 'mkdir -p "${stamp%/*}" && touch "$stamp"' EXIT

PYTHONDONTWRITEBYTECODE=1 "$repo/dotbot/bin/dotbot" -q -d "$repo" -c "$repo/server_user.conf.yaml"
