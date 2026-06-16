# Users with their own dotfiles get full config via ~/.zshrc
[[ -L "$HOME/.zshrc" ]] && return

_ZSH_DIR=${0:A:h}
source "$_ZSH_DIR/zshenv"
source "$_ZSH_DIR/aliases.zsh"

unset NVIM_APPNAME
unset MOZ_USE_XINPUT2
unset MOZ_ENABLE_WAYLAND

[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
elif [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
  source /usr/share/fzf/shell/key-bindings.zsh
fi
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

command -v oh-my-posh &>/dev/null && \
  eval "$(oh-my-posh init zsh --config ${_ZSH_DIR:h}/config/oh-my-posh/omp.yaml)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
