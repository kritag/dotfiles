#!/bin/sh
d=$(dirname "$(readlink -f "$0")")
"$d/webapp-edge.sh" create "Teams" https://teams.microsoft.com
"$d/webapp-edge.sh" create "Outlook" https://outlook.cloud.microsoft/mail
"$d/webapp-edge.sh" create "Claude" https://claude.ai
"$d/bootstrap-webapps-common.sh"
