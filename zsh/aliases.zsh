# Uses bat to colorize help switches
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias ai='codex exec --sandbox read-only --skip-git-repo-check'
alias batless='bat --paging always -l yaml'
alias cd='z'
alias diff='batdiff --paging=never'
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias ggrep="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git --no-pager grep"
alias ggrepless="git branch -a | cut -c3- | cut -d' ' -f 1 | xargs git grep"
alias gitformatpatch='XXX_PATCH=~/git/forks/patch/patch-$(date +%Y%m%d%H%M%S)-$(git rev-parse --abbrev-ref HEAD | tr / -).patch ; cd $(git rev-parse --show-toplevel) ; git format-patch  master --stdout > $XXX_PATCH ; cd - ; echo Patchfile created: $XXX_PATCH'
alias grep='rg --max-depth=1'
alias grepr='rg --max-depth=99'
alias l='ls -l'
alias la='ls -lA'
alias lat='ls -lArs age'
alias ls='eza --icons --group-directories-first --git'
alias lt='ls -lrs age'
alias lr='ls -lR'
alias mk='minikube'
alias s='SSHPASS="$SSH_PASSWORD" sshpass -e ssh -l $SSHUSER -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias sr='SSHPASS="$SSH_ROOT_PASSWORD" sshpass -e ssh -l root -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no'
alias sudo='sudo '
alias systemctl='systemctl -l'
alias tail='tailbat'
alias tree='ls --tree'
alias vim='nvim'
# `bat` coloring on journalctl
jctl() {
  journalctl "$@" | bat -l syslog -p
}
tailbat() {
  \tail -f "$@" | bat --paging=never -l log
}
mkpkg() {
  tmp=$(mktemp -d)
  cp PKGBUILD "$tmp"
  (cd "$tmp" && makepkg -si --noconfirm)
}
gr() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "not in a git repo" >&2
    return 1
  }
  z "$root"
}
# zr <Tab>: jump to a git repo zoxide knows about (completion menu via fzf-tab)
zr() { z "$@"; }
_zr() {
  local -a expl repos=(${(M)${(f)"$(zoxide query -l)"}:#$HOME/*})
  repos=(${^repos}(N/e:'[[ -d $REPLY/.git ]]':))
  _wanted -V repos expl 'git repo' compadd -f -Q -W ~/ -p '~/' -- ${repos#$HOME/}
  compstate[insert]=menu # open the menu directly instead of inserting the shared ~/ first
}

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
# alias oc='kubecolor'
alias oc="env KUBECTL_COMMAND=oc kubecolor"
alias kubectl='kubecolor'
alias k='kubectl'
alias ke='kubens'
alias kx='kubectx'
alias klogs='kubectl logs --timestamps=true'
alias cert-manager='kubectl cert-manager'

alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias zgrep='zgrep --color=auto'
alias zegrep='zegrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias xzgrep='xzgrep --color=auto'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-tilde --show-dot'
