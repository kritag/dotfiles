#!/bin/sh
# Create gnome-keyring's default keyring without a password, so the first app that wants one
# does not show the "Choose password for new keyring" prompt. Secrets in it are stored unencrypted.
d=${XDG_DATA_HOME:-$HOME/.local/share}/keyrings
[ -e "$d/default" ] && exit 0
mkdir -p "$d"
cat >"$d/Default_keyring.keyring" <<KEYRING
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
KEYRING
printf Default_keyring >"$d/default"
