#!/bin/sh
# Usage: sudo addusertodockergrp.sh [user]   (log out and in afterwards)
usermod -aG docker "${1:-${SUDO_USER:?run via sudo or pass a username}}"
