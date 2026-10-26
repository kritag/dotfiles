#!/usr/bin/env bash
# Server profile: shared zsh for every user. Run as root.
#  - hooks zsh/server-global.zsh into /etc/zshrc (zsh reads it for every interactive shell)
#  - removes the old bash hook
#  - builds the shared theme (tinty colours, bat, eza, LS_COLORS) into .server-generated/
#  - keeps the SSH_* variables through sudo
set -euo pipefail

repo="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
root=/opt/zsh-plugins
plugins=(
  "fzf-tab|https://github.com/Aloxaf/fzf-tab|v1.3.0"
  "zsh-history-substring-search|https://github.com/zsh-users/zsh-history-substring-search|v1.1.0"
)

mkdir -p "$root"
for p in "${plugins[@]}"; do
  IFS='|' read -r name url tag <<<"$p"
  dir=$root/$name
  [[ $(git -C "$dir" describe --tags --exact-match 2>/dev/null) == "$tag" ]] && continue
  rm -rf "$dir"
  git clone -q --depth 1 --branch "$tag" "$url" "$dir"
  echo "zsh plugin: $name $tag"
done

hook="$repo/zsh/server-global.zsh"
sed -i '/^# >>> dotfiles >>>$/,/^# <<< dotfiles <<<$/d' /etc/zshrc
printf '# >>> dotfiles >>>\n[[ -r %q ]] && source %q\n# <<< dotfiles <<<\n' "$hook" "$hook" >>/etc/zshrc

rm -f /etc/profile.d/dotfiles.sh

# runs as the repo owner so the generated files do not end up root-owned in the repo;
# the theme is the one last chosen with themeSwitch.sh --server, everforest on the first run
owner=$(stat -c %U "$repo")
as_owner() { sudo -H -u "$owner" "$@"; }
theme=$(cat "$repo/.server-generated/theme" 2>/dev/null || echo everforest)
as_owner "$repo/scripts/themeSwitch.sh" --server "$theme"

# shared nvim data (plugins, Mason, parsers), written only by the repo owner; XDG_CONFIG_HOME points at the repo config
install -d -o "$owner" /opt/nvim-data
# a wrapper, not an alias: $EDITOR, git and sudoedit skip aliases and would fill ~/.local/share
printf '#!/bin/sh\nXDG_DATA_HOME=/opt/nvim-data exec /usr/bin/nvim "$@"\n' >/usr/local/bin/nvim
chmod 0755 /usr/local/bin/nvim
as_owner env XDG_DATA_HOME=/opt/nvim-data XDG_CONFIG_HOME="$repo/config" NVIM_APPNAME=lazyvim \
  nvim --headless "+Lazy! sync" +qa </dev/null || echo "nvim plugin sync failed, rerun this script" >&2

# sudo drops SSH_CONNECTION, which the prompt reads to show the SSH icon and user name
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo 'Defaults env_keep += "SSH_CONNECTION SSH_CLIENT SSH_TTY"' >"$tmp"
visudo -cf "$tmp" >/dev/null
install -m 0440 "$tmp" /etc/sudoers.d/90-dotfiles-ssh-env
