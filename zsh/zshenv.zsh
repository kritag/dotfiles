# --- skip /etc/zprofile, /etc/zshrc, /etc/zlogin ------------------------------
unsetopt GLOBAL_RCS

source ${${(%):-%x}:A:h}/zshenv-common.zsh

export LANG=en_US.UTF-8
export HOSTNAME=${HOST}
export MAIL="/var/spool/mail/${USER}"
export GPG_TTY=${TTY}
export SSH_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export STEAM_FRAME_FORCE_CLOSE=1

[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"
export CLICOLOR_FORCE=1
export DOTFILES="${HOME}/.dotfiles"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,node_modules,build,dist,vendor,mnt,.steam} --type f --type l --hidden $FD_OPTIONS"
export GOPATH=$HOME/.go
export KUBECTL_COMMAND=oc
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export RAPIDFUZZ_IMPLEMENTATION=python
export XDG_CONFIG_HOME=$HOME/.config
export ZSH="${HOME}/.dotfiles/zsh"
