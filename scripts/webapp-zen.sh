#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/webapp-lib.sh"

BROWSER="zen"
LABEL="Zen"
ZEN_BIN="${ZEN_BIN:-$(command -v zen-browser || true)}"

webapp_preflight() {
  [[ -n "$ZEN_BIN" ]] || {
    echo "Error: zen-browser not found in PATH." >&2
    exit 1
  }
}

webapp_desktop_entry() {
  local name="$1" url="$2" icon="$3"
  local app_id="WebApp-$BROWSER-$(slugify "$name")"
  cat <<DESKTOP
[Desktop Entry]
Name=$name (Zen)
Exec=env MOZ_APP_REMOTINGNAME=$app_id $ZEN_BIN --no-remote --blank-window $(exec_quote "$url")
Terminal=false
Type=Application
Categories=Network;WebApp;
StartupWMClass=$app_id
Icon=$icon
DESKTOP
}

webapp_main "$@"
