# System-wide zsh for the server profile, hooked into /etc/zshrc by scripts/install-server-zsh.sh.
# Everything is shared: plugins live in /opt/zsh-plugins, config in this repo. Users keep only
# their own history and completion cache.
[[ -o interactive ]] || return
[[ $UID -eq 0 ]] && return
[[ -L $HOME/.zshrc ]] && return # user has the full dotfiles install

_ZSH_DIR=${0:A:h}
_PLUGINS=/opt/zsh-plugins

# First shell for a user (and after server_user.conf.yaml changes or a re-run of the install): link the shared tool configs.
_stamp=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-server-user
[[ -w $HOME && (! -e $_stamp || ${_ZSH_DIR:h}/server_user.conf.yaml -nt $_stamp ||
  ${_ZSH_DIR:h}/.server-generated/tinty.toml -nt $_stamp) ]] &&
  ${_ZSH_DIR:h}/scripts/bootstrap-server-user.sh >/dev/null 2>&1
unset _stamp

for _f in $HOME/.local/bin $HOME/bin $HOME/.cargo/bin; do
  [[ -d $_f && ${path[(Ie)$_f]} -eq 0 ]] && path=($_f $path)
done
[[ -r $HOME/.env ]] && source $HOME/.env # s/sr aliases read SSH_PASSWORD from here

source $_ZSH_DIR/zshenv-common.zsh
[[ -r ${_ZSH_DIR:h}/.server-generated/theme.zsh ]] && source ${_ZSH_DIR:h}/.server-generated/theme.zsh # BAT_THEME, LS_COLORS, EZA_CONFIG_DIR

setopt APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS \
  HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS HIST_VERIFY SHARE_HISTORY

source $_ZSH_DIR/aliases.zsh

# Completion: the dump lives in the user's cache; fall back to no dump when $HOME is read-only.
autoload -Uz compinit
{ mkdir -p $ZSH_CACHE_DIR && compinit -d $ZSH_CACHE_DIR/zcompdump; } 2>/dev/null || compinit -D

[[ -f $_PLUGINS/fzf-tab/fzf-tab.plugin.zsh ]] && source $_PLUGINS/fzf-tab/fzf-tab.plugin.zsh
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f $_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh ]] &&
  source $_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh

for _f in /usr/share/fzf/key-bindings.zsh /usr/share/fzf/shell/key-bindings.zsh; do
  [[ -f $_f ]] && {
    source $_f
    break
  }
done

[[ -r ${_ZSH_DIR:h}/.server-generated/fzf.sh ]] && source ${_ZSH_DIR:h}/.server-generated/fzf.sh
source $_ZSH_DIR/zshkeybindings.zsh
source $_ZSH_DIR/zstyle.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
compdef _ssh_hosts sshpass s sr
compdef _journalctl jctl
compdef _zr zr
command -v zsh-patina >/dev/null && eval "$(zsh-patina activate)"
command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh --config ${_ZSH_DIR:h}/config/oh-my-posh/omp.yaml)"
unset _f
