#!/usr/bin/env zsh
set -eo pipefail # no -u: znap's ls helper reads $aliases[ls], unset outside an interactive shell

export ZDOTDIR="$HOME"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/bin:/bin"

source "${ZNAP_DIR:-$HOME/git/znap/znap}/znap.zsh"

znap pull
