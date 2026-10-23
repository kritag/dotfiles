#!/usr/bin/env bash
# Server profile: shared zsh for every user. Run as root.
#  - clones the plugins that have no Fedora package into /opt/zsh-plugins, pinned to a tag
#  - hooks zsh/server-global.zsh into /etc/zshrc (zsh reads it for every interactive shell)
#  - removes the old bash hook
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

# sudo drops SSH_CONNECTION, which the prompt reads to show the SSH icon and user name
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo 'Defaults env_keep += "SSH_CONNECTION SSH_CLIENT SSH_TTY"' >"$tmp"
visudo -cf "$tmp" >/dev/null
install -m 0440 "$tmp" /etc/sudoers.d/90-dotfiles-ssh-env
