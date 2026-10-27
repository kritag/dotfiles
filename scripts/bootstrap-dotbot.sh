#!/usr/bin/env bash
# Install the dotbot binary when missing: AUR on Arch/CachyOS, copr on Fedora.
set -euo pipefail

command -v dotbot >/dev/null && exit 0

. /etc/os-release
case " ${ID} ${ID_LIKE:-} " in
  *" arch "*)
    "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/bootstrap-yay.sh"
    yay -S --needed --noconfirm dotbot
    ;;
  *" fedora "*)
    sudo dnf copr enable -y bonvaffel/cli-tools
    sudo dnf install -y dotbot
    ;;
  *)
    echo "Unsupported distro ${ID}: install dotbot manually" >&2
    exit 1
    ;;
esac
