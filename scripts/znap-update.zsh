#!/usr/bin/env zsh
set -euo pipefail

export ZDOTDIR="$HOME"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:/bin"

source "${ZNAP_DIR:-$HOME/git/znap/znap}/znap.zsh"

alias ls='ls -d' # znap's ls helper reads $aliases[ls] under nounset, unset outside an interactive shell; needs 2+ words
znap pull
