#!/bin/sh
d=$(dirname "$(readlink -f "$0")")
"$d/webapp-zen.sh" create "ChatGPT" https://chatgpt.com
"$d/bootstrap-webapps-common.sh"
