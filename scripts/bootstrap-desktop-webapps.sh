#!/bin/sh
webapp-zen create "ChatGPT" https://chatgpt.com
"$(dirname "$(readlink -f "$0")")/bootstrap-webapps-common.sh"
