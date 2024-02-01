zstyle -e ':completion:*' hosts 'reply=($(< ~/.ssh/ssh_hosts))'
#zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%p
# cache to proxy list of results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*:functions' ignore-patterns '_*'
# if you end up using a directory as argument
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':fzf-tab:complete:*' extra-opts --preview-window=:hidden
zstyle ':fzf-tab:*' show-group full
#zstyle ':fzf-tab:*' fzf-min-height '1000'
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':completion:complete:*:options' sort false
# --complete
#zstyle ':fzf-tab:complete:*' fzf-preview 'less ${realpath#--*=}'
# --user-expand
zstyle ':fzf-tab:user-expand::' fzf-preview 'less $word'
# -parameter
zstyle ':fzf-tab:complete:((-parameter-|unset):|(export|typeset|declare|local):argument-rest)' fzf-preview 'echo ${(P)word}'
# -equal
zstyle ':fzf-tab:complete:(-equal-:|(\\|*/|)(sudo|proxychains|strace):argument-1|pudb:option--pre-run-1)' fzf-preview 'less =$word'
# -command-
 zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*'fzf-preview 'echo ${(P)word}'
# has
zstyle ':fzf-tab:complete:(\\|*/|)has:argument-rest' fzf-preview 'case $group in
"external command")
  has $word
  ;;
esac'
# Systemctl
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:systemctl:*' fzf-flags --preview-window=down:0:wrap
# TLDR
zstyle ':fzf-tab:complete:tldr:*' fzf-preview 'tldr --color always $word'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
# Man
zstyle ':fzf-tab:complete:(\\|*/|)man:' fzf-preview 'man $word | bat -lman'
zstyle ':fzf-tab:complete:(\\|*/|)bat:argument-rest' fzf-preview 'case $group in
subcommand)
  bat cache --help | bat -lhelp
  ;;
*)
  [[ -f ${realpath#--*=} ]] && bat ${realpath#--*=} || less ${realpath#--*=}
  ;;
esac'
# Keymap
zstyle ':fzf-tab:complete:(\\|)bindkey:option-M-1' fzf-preview 'bindkey -M$word | bat -ltsv'
# gh
zstyle ':fzf-tab:complete:gh:' fzf-preview 'gh help $word | bat -lhelp'
# git
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'
# jq
zstyle ':fzf-tab:complete:(\\|*/|)jq:argument-rest' fzf-preview 'jq -Cr . $realpath 2>/dev/null || less $realpath'
# pkill
zstyle ':fzf-tab:complete:(\\|*/|)(pkill:o-argument-rest|killall:argument-1)' fzf-preview 'ps -C$word -wocmd --no-headers | bat -lsh'
# ps
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps -p$word -wocmd --no-headers | bat -lsh'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
# read
zstyle ':fzf-tab:complete:(\\|)read:argument-1' fzf-preview 'echo ${(P)word}'

_FZF_TAB_FZF_FLAGS=(
    '--height=80%' \
    '--layout=reverse' \
)
zstyle ':fzf-tab:complete:*' fzf-preview '([[ -f $realpath ]] && bat --color=always "$realpath") || ([[ -d $realpath ]] && (eza --long --git --group-directories-first --icons --color=always "$realpath"))'
zstyle ':fzf-tab:complete:*' fzf-flags '--preview-window=50%' $_FZF_TAB_FZF_FLAGS
