#!/bin/sh
d=$(dirname "$(readlink -f "$0")")
"$d/webapp-zen.sh" create "Discord" https://discord.com/channels/@me
"$d/webapp-zen.sh" create "YouTube" https://youtube.com
