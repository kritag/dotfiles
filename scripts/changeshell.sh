#!/bin/sh
chsh -s "$(command -v zsh)" "${SUDO_USER:-$USER}"
