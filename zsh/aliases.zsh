# Uses bat to colorize help switches
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias diff='batdiff --paging=never'
alias cat='bat --paging=never'
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias ggrep="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git --no-pager grep"
alias ggrepless="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git grep"
alias gitformatpatch='XXX_PATCH=~/git/forks/patch/patch-$(date +%Y%m%d%H%M%S)-$(git rev-parse --abbrev-ref HEAD | tr / -).patch ; cd $(git rev-parse --show-toplevel) ; git format-patch  master --stdout > $XXX_PATCH ; cd - ; echo Patchfile created: $XXX_PATCH'
alias grep='rg --max-depth=1'
alias l='ls -l'
alias la='ls -lA'
alias ls='eza --icons --group-directories-first'
alias lt='ls -lrs age'
alias lat='ls -lArs age'
alias mk='minikube'
alias pf='PF_INFO="ascii title os host kernel wm editor uptime shell de palette" /usr/local/bin/pfetch'
# Using sshpass to manage passwords to servers when SSH-key is not used. Stored in 600 'pass' and 'passe' files. Remember to set $SSHUSER in .env
alias s='sshpass -f $HOME/passe ssh -l $SSHUSER -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias sr='sshpass -f $HOME/pass ssh -l root -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias sudo='sudo '
alias tail='tailbat'
alias tree='ls --tree'
alias vim='lvim'
# To get bat coloring on journalctl
jctl(){
   journalctl $@ | bat -l syslog -p}
tailbat(){
    \tail -f $@ | bat --paging=never -l log}

# Git
alias g='git'
alias ga='git add'
alias gam='git am'
alias gap='git apply'
alias gbs='git bisect'
alias gbl='git blame -w'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit'
alias gd='git diff'
alias gf='git fetch'
alias ghh='git help'
alias glg='git log'
alias gm='git merge'
alias gl='git pull'
alias gp='git push'
alias grb='git rebase'
alias gr='git remote'
alias grh='git reset'
alias grs='git restore'
alias grev='git revert'
alias grm='git rm'
alias gsh='git show'
alias gsta='git stash'
alias gst='git status'
alias gsu='git submodule'
alias gsw='git switch'
alias gwt='git worktree'

# Python
alias py='python3'
# Run proper IPython regarding current virtualenv (if any)
alias ipython="python3 -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
# Share local directory as a HTTP server
alias pyserver="python3 -m http.server"

# PIP
alias pip="noglob pip"
alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipun="pip uninstall"
alias pipgi="pip freeze | grep"
alias piplo="pip list -o"
alias pipreq="pip freeze > requirements.txt"
alias pipir="pip install -r requirements.txt"

# Kubernetes
alias kubectl='kubecolor'
alias k='kubectl'
alias ke='kubens'
alias kx='kubectx'
alias klogs='kubectl logs --timestamps=true'
alias cert-manager='kubectl cert-manager'
