#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/webapp-lib.sh"

BROWSER="edge"
LABEL="Edge"
EDGE_BIN="${EDGE_BIN:-microsoft-edge-stable}"
# Webapps run in their own profile, separate from the main browsing instance.
# An --app window cannot host a tab, so while one is the last-active window in
# the main instance, Edge is forced to open xdg-open URLs (oc login --web,
# Slack links) in a new window instead of a tab.
EDGE_APPS_PROFILE="${EDGE_APPS_PROFILE:-$HOME/.config/microsoft-edge-apps}"
EDGE_FLAGS="--ozone-platform-hint=auto --enable-features=WebRTCPipeWireCapturer,WebRtcPipeWireCapturer,WebRtcPipeWireCamera --user-data-dir=$EDGE_APPS_PROFILE"

webapp_desktop_entry() {
  local name="$1" url="$2" icon="$3"
  cat <<DESKTOP
[Desktop Entry]
Name=$name (Edge)
Exec=$EDGE_BIN $EDGE_FLAGS $(exec_quote "--app=$url")
Terminal=false
Type=Application
Categories=Network;WebApp;
Icon=$icon
DESKTOP
}

webapp_main "$@"
