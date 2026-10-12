#!/bin/sh
webapp-edge create "Teams" https://teams.microsoft.com
webapp-edge create "Outlook" https://outlook.office365.com/mail
webapp-edge create "Claude" https://claude.ai
"$(dirname "$(readlink -f "$0")")/bootstrap-webapps-common.sh"
