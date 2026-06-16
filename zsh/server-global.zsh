_ZSH_DIR=${0:A:h}
source "$_ZSH_DIR/zshenv"
source "$_ZSH_DIR/aliases.zsh"

unset NVIM_APPNAME
unset MOZ_USE_XINPUT2
unset MOZ_ENABLE_WAYLAND

export ZNAP_DIR=/opt/znap/znap
source "$_ZSH_DIR/zshrc"
