#!/bin/sh
# readlink -f: under sudo, command -v finds /usr/sbin/zsh, which is not in /etc/shells
chsh -s "$(readlink -f "$(command -v zsh)")" "${SUDO_USER:-$USER}"
