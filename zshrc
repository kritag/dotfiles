zmodload zsh/zprof
# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

PATH="${PATH}:$HOME/.local/bin:$HOME/bin:/home/linuxbrew/.linuxbrew/bin:${KREW_ROOT:-$HOME/.krew}/bin"; export PATH;

# Adds completion from brew
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

autoload -Uz compinit
ZSH_COMPDUMP=${ZSH_COMPDUMP:-${ZDOTDIR:-~}/.zcompdump}

# cache .zcompdump for about a day
if [[ $ZSH_COMPDUMP(#qNmh-20) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -i -d "$ZSH_COMPDUMP"; touch "$ZSH_COMPDUMP"
fi
{
  # compile .zcompdump
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

source $HOME/.env

export ZSH_CACHE_DIR="$HOME/.cache"

export EDITOR=vim
export SYSTEMD_EDITOR=vim

source $HOME/.aliases

# Ensure up and down arrow works for searching history
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Ensuring that autocomplete works with sshpass aliases
setopt COMPLETE_ALIASES
compdef _ssh_hosts s sr
zstyle -e ':completion:*' hosts 'reply=($(< ~/.ssh/ssh_hosts))'

# Display system info https://github.com/dylanaraps/pfetch
PF_INFO="ascii title os host kernel wm editor uptime shell palette" /usr/local/bin/pfetch 

# Sourcing k8s related stuff and prompt if using k8s
source $HOME/.zshrc-k8s.zsh

# Theme env vars
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_FULL_CWD=1
DRACULA_DISPLAY_NEW_LINE=1

# Fix zsh-syntax hightlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

#
ZSH_COLORIZE_STYLE="dracula"

