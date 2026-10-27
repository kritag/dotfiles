#!/bin/env bash
# Teams/Outlook run in their own --user-data-dir (see webapp-edge-*.desktop), so
# they form a separate Edge instance from the main browsing profile. That keeps
# the main instance free of --app windows -- an --app window cannot host a tab,
# and if one is the last-active window there, xdg-open URLs are forced into a new
# window instead of a tab.
#
# The two webapps SHARE the apps profile, so they must not race each other for
# its singleton: start Teams, wait for it, then let Outlook hand off to it.
#
# Every launch is detached: runapp -o runs the command in the foreground, so a
# first-instance Edge blocks the caller for the whole session.

# Keep in sync with webapp-edge-*.desktop
edge_flags=(--ozone-platform-hint=auto
  --enable-features=WebRTCPipeWireCapturer,WebRtcPipeWireCapturer,WebRtcPipeWireCamera)
apps_profile=(--user-data-dir="$HOME/.config/microsoft-edge-apps")

launch() {
  setsid runapp -o -- microsoft-edge-stable "${edge_flags[@]}" "$@" >/dev/null 2>&1 &
}

waitfor() { # $1 = window class regex; give up after 20s
  local _
  for _ in $(seq 100); do
    hyprctl clients -j | jq -e --arg c "$1" '.[] | select(.class | test($c))' \
      >/dev/null 2>&1 && return 0
    sleep 0.2
  done
  echo "startEdgeStack: no window matching /$1/ after 20s" >&2
  return 1
}

# Edge only checks for a notification daemon at startup; if it launches before
# DMS owns org.freedesktop.Notifications, webapp notifications stay silent.
for _ in $(seq 150); do
  busctl --user status org.freedesktop.Notifications >/dev/null 2>&1 && break
  sleep 0.2
done

launch

launch "${apps_profile[@]}" --app=https://teams.microsoft.com
waitfor '^msedge-teams\.microsoft\.com'

launch "${apps_profile[@]}" --app=https://outlook.cloud.microsoft/mail
waitfor '^msedge-outlook\.cloud\.microsoft'

waitfor '^microsoft-edge$'
