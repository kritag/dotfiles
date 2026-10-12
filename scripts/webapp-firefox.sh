#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/webapp-lib.sh"

BROWSER="firefox"
LABEL="Firefox"
PROFILE_NAME="WebApps"

webapp_desktop_entry() {
  local name="$1" url="$2" icon="$3"
  local app_id="WebApp-$BROWSER-$(slugify "$name")"
  cat <<DESKTOP
[Desktop Entry]
Name=$name (Firefox)
Exec=firefox --no-remote -P "$PROFILE_NAME" --new-window --name "$app_id" $(exec_quote "$url")
Terminal=false
Type=Application
Categories=Network;WebApp;
StartupWMClass=$app_id
Icon=$icon
DESKTOP
}

webapp_main "$@"
