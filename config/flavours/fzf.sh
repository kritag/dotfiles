# -Tokyo night dark
# Scheme author: Michaël Ball
# Template author: Tinted Theming (https://github.com/tinted-theming)

export FZF_DEFAULT_OPTS=" \
  --history=$HOME/.fzfhistory \
  --layout=reverse \
  --color=bg:#16161e,fg:#c0caf5,hl:#ff9e64\
  --color=bg+:#2f3549,fg+:#c0caf5,hl+:#7dcfff\
  --color=info:#73daca,border:#7aa2f7,prompt:#9ece6a\
  --color=pointer:#16161e,marker:#9ece6a,spinner:#bb9af7,header:#f7768e \
--pointer=❯ \
--multi"

_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=bg:#16161e,fg:#c0caf5,hl:#ff9e64'
  '--color=bg+:#2f3549,fg+:#c0caf5,hl+:#7dcfff'
  '--color=info:#73daca,border:#7aa2f7,prompt:#9ece6a'
  '--color=pointer:#16161e,marker:#9ece6a,spinner:#bb9af7,header:#f7768e'
  '--pointer=❯'
  '--multi'
)