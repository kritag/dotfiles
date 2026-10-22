#!/usr/bin/env zsh
set -euo pipefail

export ZDOTDIR="$HOME"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:/bin"

source "${ZNAP_DIR:-$HOME/git/znap/znap}/znap.zsh"

znap pull
