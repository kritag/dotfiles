#!/bin/env bash
# Start the tabbed Edge window FIRST so it owns the Chromium singleton, then let
# the --app webapps hand off to it. If a webapp wins the race it takes the lock,
# and since an --app window has no tab strip every xdg-open URL is forced into a
# new window instead of a tab.

uwsm-app -- microsoft-edge.desktop

# The tabbed window's class is exactly "microsoft-edge"; the webapps get
# msedge-<host>-Default. Wait up to 20s for it.
for _ in $(seq 100); do
  hyprctl clients -j | jq -e '.[] | select(.class == "microsoft-edge")' >/dev/null 2>&1 && break
  sleep 0.2
done

uwsm-app -- webapp-edge-teams.desktop
uwsm-app -- webapp-edge-outlook.desktop
