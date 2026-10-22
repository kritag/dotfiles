zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':completion:*' accept-exact false
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR/zcompcache
zstyle ':completion:*:functions' ignore-patterns '_*'
# if you end up using a directory as argument
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':fzf-tab:complete:*' extra-opts --preview-window=:hidden
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:*:*' query-string input
# --user-expand
zstyle ':fzf-tab:user-expand::' fzf-preview 'less $word'
# -parameter
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|unset|export|typeset|declare|local|read|expand):*' fzf-preview 'echo ${(P)word}'
# -equal
zstyle ':fzf-tab:complete:(-equal-:|(\\|*/|)(sudo|proxychains|strace):argument-1|pudb:option--pre-run-1)' fzf-preview 'less =$word'
# -command-
zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'
# has
zstyle ':fzf-tab:complete:(\\|*/|)has:argument-rest' fzf-preview 'case $group in
"external command")
  has $word
  ;;
esac'
# journalctl
zstyle ':fzf-tab:complete:(\\|*/|)journalctl:*' fzf-preview 'case $group in
"boot "*) journalctl --no-pager -n 200 -b $word | bat -p -l log --color=always ;;
"/dev files") journalctl --no-pager -n 200 -b /dev/$word | bat -p -l log --color=always ;;
commands) journalctl --no-pager -n 200 $word | bat -p -l log --color=always ;;
"possible values") journalctl --no-pager -n 200 -u $word | bat -p -l log --color=always ;;
esac'
# Systemctl
# $word may be a user unit: the command line isn't visible here, so fall back to --user
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null || SYSTEMD_COLORS=1 systemctl --user status $word'
# group header colours (Everforest) instead of the terminal's ANSI palette
zstyle ':fzf-tab:*' group-colors $'\e[38;2;127;187;179m' $'\e[38;2;230;152;117m' $'\e[38;2;167;192;128m' $'\e[38;2;214;153;182m' $'\e[38;2;219;188;127m' $'\e[38;2;131;192;146m' $'\e[38;2;230;126;128m'
zstyle ':fzf-tab:complete:systemctl:*' fzf-flags --preview-window=down:0:wrap $_FZF_TAB_FZF_FLAGS
# TLDR
zstyle ':fzf-tab:complete:tldr:*' fzf-preview 'tldr --color always $word'
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
zstyle ':fzf-tab:complete:git-(branch|switch):argument-1' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
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
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap $_FZF_TAB_FZF_FLAGS

# Only preview real files/dirs: with an empty $realpath lesspipe prints its LESSOPEN setup text
zstyle ':fzf-tab:complete:*:*' fzf-preview '
if [[ ! -e ${(Q)realpath} ]]; then
  :
elif [ -x /usr/libexec/lesspipe/lesspipe.sh ]; then
  /usr/libexec/lesspipe/lesspipe.sh ${(Q)realpath}
else
  lesspipe.sh ${(Q)realpath}
fi'
zstyle ':fzf-tab:complete:*' fzf-flags '--preview-window=50%,border-rounded' $_FZF_TAB_FZF_FLAGS
