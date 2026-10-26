export EDITOR=nvim MANPAGER="nvim +Man!" SYSTEMD_EDITOR=nvim SYSTEMD_PAGER=
export GLOW_STYLE=$HOME/.config/glow/colors.json
export LG_CONFIG_FILE=$HOME/.config/lazygit/config.yaml,$HOME/.config/lazygit/colors.yaml
export BAT_PAGER="less -R" LESS="-IRs" COLORTERM=truecolor
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,node_modules,build,dist,vendor} --type f --type l --hidden $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#757575"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=bg=black,fg=cyan,bold
HISTFILE=$HOME/.zsh_history HISTSIZE=50000 SAVEHIST=50000
WORDCHARS='*?[]~&;!#$%^(){}<>' # no "/", so Ctrl-W deletes one path component
[[ -d $HOME/.config/lazyvim ]] && export NVIM_APPNAME=lazyvim
for _f in /usr/libexec/lesspipe/lesspipe.sh /usr/bin/lesspipe.sh; do
  [[ -x $_f ]] && {
    export LESSOPEN="|$_f %s"
    break
  }
done
unset _f
