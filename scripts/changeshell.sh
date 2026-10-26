#!/bin/sh
chsh -s "$(readlink -f "$(command -v zsh)")" "${SUDO_USER:-$USER}"
