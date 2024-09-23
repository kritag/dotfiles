export BAT_PAGER="less -R"
export CLICOLOR_FORCE=1
export COLORTERM=truecolor
export DOTFILES="${HOME}/.dotfiles"
export EDITOR=lvim
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.node_modules,bulid,dist,vender,mnt} --type f --type l --hidden $FD_OPTIONS"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--layout=reverse \
--history=$HOME/.fzfhistory"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export HISTFILE=$HOME/.zsh_history
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=bg=black,fg=cyan,bold
export HISTSIZE=50000
export KUBECTL_COMMAND=oc
export LESS="-IRs"
#export LESSOPEN="| bat --pager=always -n %s"
#export LESSOPEN='|~/.lessfilter %s'
export LESSOPEN='|/usr/bin/lesspipe.sh %s'
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/mauve.yml" 
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export MANPAGER="nvim +Man!"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export MYVIMRC="${XDG_CONFIG_HOME}/nvim/init.vim"
export POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=224
export POWERLEVEL9K_DIR_FOREGROUND=223
export POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=222
export POWERLEVEL9K_EXAMPLE_FOREGROUND=208
export POWERLEVEL9K_ICON_PADDING=moderate
export POWERLEVEL9K_KUBECONTEXT_CONTENT_EXPANSION='%F{1}${P9K_KUBECONTEXT_NAME%%/*}%f/%F{2}${${P9K_KUBECONTEXT_CLUSTER#api-}%-*-*:*}%f:%F{3}$P9K_KUBECONTEXT_NAMESPACE%f'
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs newline prompt_char)
export POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=13
export POWERLEVEL9K_TRANSIENT_PROMPT=always
export POWERLEVEL9K_VCS_BRANCH_ICON="%fon %F{147}\uE0A0 "
export POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export SAVEHIST=10000
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/ssh-agent.socket
export SYSTEMD_EDITOR=lvim
export WORDCHARS='*?[]~&;!#$%^(){}<>'
export XDG_CONFIG_HOME=$HOME/.config
export ZSH="${HOME}/.dotfiles/zsh"
export ZSH_CACHE_DIR="$HOME/.cache"
unset POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION
unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
unset POWERLEVEL9K_PROMPT_ADD_NEWLINE
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
