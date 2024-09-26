export BAT_PAGER="less -R"
export CLICOLOR_FORCE=1
export COLORTERM=truecolor
export DOTFILES="${HOME}/.dotfiles"
export EDITOR=nvim
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.node_modules,bulid,dist,vender,mnt} --type f --type l --hidden $FD_OPTIONS"
export FZF_DEFAULT_OPTS=" \
--history=$HOME/.fzfhistory \
--layout=reverse \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a,border:#94e2d5 \
--pointer=❯ \
--multi"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export HISTFILE=$HOME/.zsh_history
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=bg=black,fg=cyan,bold
export HISTSIZE=50000
export KUBECTL_COMMAND=oc
export LESS="-IRs"
export LESSOPEN='|/usr/bin/lesspipe.sh %s'
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/mauve.yml" 
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export MANPAGER="nvim +Man!"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export MYVIMRC="${XDG_CONFIG_HOME}/nvim/init.vim"
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export SAVEHIST=10000
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/ssh-agent.socket
export SYSTEMD_EDITOR=nvim
export WORDCHARS='*?[]~&;!#$%^(){}<>'
export XDG_CONFIG_HOME=$HOME/.config
export ZSH="${HOME}/.dotfiles/zsh"
export ZSH_CACHE_DIR="$HOME/.cache"
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
