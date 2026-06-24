[[ $UID -eq 0 ]] && return
[[ -f "$HOME/.bashrc" ]] && [[ "$(head -1 $HOME/.bashrc)" != "# dotfiles-managed" ]] && [[ -L "$HOME/.bashrc" ]] && return

# Prompt
__build_ps1() {
  local exit=$?
  local reset='\[\e[0m\]'
  local bold='\[\e[1m\]'
  local blue='\[\e[34m\]'
  local magenta='\[\e[35m\]'
  local red='\[\e[31m\]'
  local yellow='\[\e[33m\]'

  local git_info=''
  local branch
  branch=$(git branch 2>/dev/null | grep '^\*' | cut -c3-)
  [[ -n "$branch" ]] && git_info=" ${yellow}${branch}${reset}"

  local prompt_color=$magenta
  [[ $exit -ne 0 ]] && prompt_color=$red

  PS1="${bold}${blue}\w${reset}${git_info} ${magenta}\u@\h${reset}\n${prompt_color}❯${reset} "
}
PROMPT_COMMAND='__build_ps1'

# Env
export BAT_PAGER="less -R"
export CLICOLOR_FORCE=1
export COLORTERM=truecolor
export EDITOR=nvim
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.node_modules,build,dist,vendor} --type f --type l --hidden $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoredups:erasedups
export LESS="-IRs"
export MANPAGER="nvim +Man!"
export SYSTEMD_EDITOR=nvim
export SYSTEMD_PAGER=

if [ -x /usr/libexec/lesspipe/lesspipe.sh ]; then
  export LESSOPEN='|/usr/libexec/lesspipe/lesspipe.sh %s'
elif [ -x /usr/bin/lesspipe.sh ]; then
  export LESSOPEN='|/usr/bin/lesspipe.sh %s'
fi

command -v vivid &>/dev/null && export LS_COLORS="$(vivid generate gruvbox-dark-hard)"

shopt -s histappend
shopt -s cmdhist

# Aliases
alias diff='batdiff --paging=never'
alias grep='rg --max-depth=1'
alias grepr='rg --max-depth=99'
alias l='ls -l'
alias la='ls -lA'
alias ls='eza --icons --group-directories-first --git'
alias lt='ls -lrs age'
alias lr='ls -lR'
alias sudo='sudo '
alias systemctl='systemctl -l'
alias tree='ls --tree'
alias vim='nvim'

alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias glg='git log'
alias gm='git merge'
alias gp='git push'
alias grb='git rebase'
alias grh='git reset'
alias grs='git restore'
alias gst='git status'
alias gsw='git switch'

alias py='python3'
alias pip="noglob pip" 2>/dev/null || alias pip='pip'
alias s='SSHPASS="$SSH_PASSWORD" sshpass -e ssh -l $SSHUSER -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias sr='SSHPASS="$SSH_ROOT_PASSWORD" sshpass -e ssh -l root -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'

jctl() { journalctl "$@" | bat -l syslog -p; }
tailbat() { \tail -f "$@" | bat --paging=never -l log; }

# fzf
if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
  source /usr/share/fzf/key-bindings.bash
elif [[ -f /usr/share/fzf/shell/key-bindings.bash ]]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi
if [[ -f /opt/fzf-tab-completion/bash/fzf-bash-completion.sh ]]; then
  source /opt/fzf-tab-completion/bash/fzf-bash-completion.sh
  bind -x '"\t": fzf_bash_completion'
elif [[ -f /usr/share/fzf/completion.bash ]]; then
  source /usr/share/fzf/completion.bash
elif [[ -f /usr/share/fzf/shell/completion.bash ]]; then
  source /usr/share/fzf/shell/completion.bash
fi

command -v zoxide &>/dev/null && eval "$(zoxide init bash)" && alias cd='z'
