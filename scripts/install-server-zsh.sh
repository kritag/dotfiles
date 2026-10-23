#!/usr/bin/env bash
# Server profile: shared zsh for every user. Run as root.
#  - clones the plugins that have no Fedora package into /opt/zsh-plugins, pinned to a tag
#  - hooks zsh/server-global.zsh into /etc/zshrc (zsh reads it for every interactive shell)
#  - removes the old bash hook
#  - builds the fzf colours with tinty into .server-generated/, shared by all users
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

# tinty runs as the repo owner so the generated files do not end up root-owned in the repo
gen="$repo/.server-generated"
owner=$(stat -c %U "$repo")
as_owner() { sudo -H -u "$owner" "$@"; }
as_owner mkdir -p "$gen"
sed "s|@REPO@|$repo|g" "$repo/config/tinty-server.toml" | as_owner tee "$gen/tinty.toml" >/dev/null
tinty_server() { as_owner tinty --config "$gen/tinty.toml" --data-dir "$gen/tinty-data" "$@" </dev/null; }
tinty_server sync >/dev/null
tinty_server build --quiet
tinty_server apply "$(sed -n 's/^default-scheme *= *"\(.*\)"/\1/p' "$gen/tinty.toml")" >/dev/null

# shared nvim data (plugins, Mason, parsers), written only by the repo owner; XDG_CONFIG_HOME points at the repo config
install -d -o "$owner" /opt/nvim-data
as_owner env XDG_DATA_HOME=/opt/nvim-data XDG_CONFIG_HOME="$repo/config" NVIM_APPNAME=lazyvim \
  nvim --headless "+Lazy! sync" +qa </dev/null || echo "nvim plugin sync failed, rerun this script" >&2

# sudo drops SSH_CONNECTION, which the prompt reads to show the SSH icon and user name
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo 'Defaults env_keep += "SSH_CONNECTION SSH_CLIENT SSH_TTY"' >"$tmp"
visudo -cf "$tmp" >/dev/null
install -m 0440 "$tmp" /etc/sudoers.d/90-dotfiles-ssh-env
