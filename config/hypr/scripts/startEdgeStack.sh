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

launch webapp-edge-teams.desktop
waitfor '^msedge-teams\.microsoft\.com'

launch webapp-edge-outlook.desktop
waitfor '^msedge-outlook\.office365\.com'

waitfor '^microsoft-edge$'
