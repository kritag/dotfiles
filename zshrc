zmodload zsh/zprof
# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

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
#source $HOME/antigen.zsh
#antigen init .antigenrc
#source $HOME/bin/zsh-syntax-highlighting.zshrc
#source $HOME/bin/manpages.zshrc
source $HOME/.env

export ZSH_CACHE_DIR="$HOME/.cache"

export EDITOR=vim
export SYSTEMD_EDITOR=vim

alias sudo='sudo '
alias gitformatpatch='XXX_PATCH=~/git/forks/patch/patch-$(date +%Y%m%d%H%M%S)-$(git rev-parse --abbrev-ref HEAD | tr / -).patch ; cd $(git rev-parse --show-toplevel) ; git format-patch master --stdout > $XXX_PATCH ; cd - ; echo Patchfile created: $XXX_PATCH'
alias ggrep="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git --no-pager grep"
alias ggrepless="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git grep"

# Using lsdeluxe instead of ls
alias ls='lsd'

# Using sshpass to manage passwords to servers when SSH-key is not used. Stored in 600 'pass' and 'passe' files. Remember to set $SSHUSER in .env
alias sr='sshpass -f $HOME/pass ssh -l root -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias s='sshpass -f $HOME/passe ssh -l $SSHUSER -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'

# Ensuring that autocomplete works with sshpass aliases
setopt COMPLETE_ALIASES
compdef _ssh_hosts s sr
zstyle -e ':completion:*' hosts 'reply=($(< ~/.ssh/ssh_hosts))'

# Display system info https://github.com/dylanaraps/pfetch
PF_INFO="ascii title os host kernel wm editor uptime shell palette" /usr/local/bin/pfetch 
PATH="${PATH}:/home/tageskri/.local/bin:/home/tageskri/bin:/home/linuxbrew/.linuxbrew/bin:${KREW_ROOT:-$HOME/.krew}/bin"; export PATH;

# Source k8s related functions and kube-ps1 prompt
source $HOME/.zshrc-k8s.zsh

# Adds completion from brew
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Theme env vars
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_FULL_CWD=1
DRACULA_DISPLAY_NEW_LINE=1

# Fix zsh-syntax hightlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

#
ZSH_COLORIZE_STYLE="dracula"

