#!/usr/bin/env bash
# Build yabridge-wine10-git with Arch's default flags. CachyOS's makepkg.conf (-march=native -O3, lto)
# produces a yabridge-host that crashes every plugin with a Wine stack overflow at initialize.
# Run directly to rebuild after an upgrade; the profile only calls it when yabridge is missing.
set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

cp /etc/makepkg.conf "$tmp/makepkg.conf"
cat >>"$tmp/makepkg.conf" <<'EOF'
CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt"
CXXFLAGS="$CFLAGS"
LDFLAGS="-Wl,-O1 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now"
LTOFLAGS=""
OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug !lto)
EOF

cd "$tmp"
yay -G yabridge-wine10-git
cd yabridge-wine10-git
makepkg -si --noconfirm --config "$tmp/makepkg.conf"
