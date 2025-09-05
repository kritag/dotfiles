[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh" && alias sshpass="TERM=xterm-256color sshpass"
export BAT_PAGER="less -R"
export CLICOLOR_FORCE=1
export COLORTERM=truecolor
export DOTFILES="${HOME}/.dotfiles"
export EDITOR=nvim
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.node_modules,bulid,dist,vender,mnt,.steam} --type f --type l --hidden $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export GLOW_STYLE="$HOME/.config/glow/colors.json"
export HISTFILE=$HOME/.zsh_history
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=bg=black,fg=cyan,bold
export HISTSIZE=50000
export KUBECTL_COMMAND=oc
export LESS="-IRs"
export LESSOPEN='|/usr/bin/lesspipe.sh %s'
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/colors.yml"
export LS_COLORS="$(vivid generate ~/.config/vivid/themes/nord.yml)"
export MANPAGER="nvim +Man!"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export NVIM_APPNAME='lazyvim'
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export SAVEHIST=10000
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SYSTEMD_EDITOR=nvim
export WORDCHARS='*?[]~&;!#$%^(){}<>'
export XDG_CONFIG_HOME=$HOME/.config
export ZSH="${HOME}/.dotfiles/zsh"
export ZSH_CACHE_DIR="$HOME/.cache"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#757575"
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#414868"
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
