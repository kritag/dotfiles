#!/bin/env bash
# Start the tabbed Edge window FIRST so it owns the Chromium singleton, then let
# the --app webapps hand off to it. If a webapp wins the race it takes the lock,
# and since an --app window has no tab strip, every xdg-open URL is then forced
# into a new window instead of a tab.
#
# Every launch is detached: uwsm-app evals its systemd-run command in the
# foreground, so a first-instance Edge blocks the caller for the whole session.

launch() { setsid uwsm-app -- "$1" >/dev/null 2>&1 & }

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

launch microsoft-edge.desktop
waitfor '^microsoft-edge$'

launch webapp-edge-teams.desktop
waitfor '^msedge-teams\.microsoft\.com'

launch webapp-edge-outlook.desktop
waitfor '^msedge-outlook\.office365\.com'
