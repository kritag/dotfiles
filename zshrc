#zmodload zsh/zprof
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

plugins=(
    git 
    gitfast
    oc
    cp 
    colored-man-pages 
    colorize 
    kube-ps1
    kubectx
    kubectl
    pip 
    python 
    zsh-autosuggestions
    zsh-syntax-highlighting
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $HOME/bin/zsh-syntax-highlighting.zshrc
source $HOME/bin/manpages.zshrc
source $ZSH/oh-my-zsh.sh
source $HOME/.env

export EDITOR=vim
export SYSTEMD_EDITOR=vim

alias sudo='sudo '
alias gitformatpatch='XXX_PATCH=~/git/forks/patch/patch-$(date +%Y%m%d%H%M%S)-$(git rev-parse --abbrev-ref HEAD | tr / -).patch ; cd $(git rev-parse --show-toplevel) ; git format-patch master --stdout > $XXX_PATCH ; cd - ; echo Patchfile created: $XXX_PATCH'
alias ggrep="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git --no-pager grep"
alias ggrepless="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git grep"

# Using lsdeluxe instead of ls, see https://github.com/Peltoche/lsd
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

autoload -U +X compinit && compinit

