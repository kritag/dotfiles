# -Nord
# Scheme author: arcticicestudio
# Template author: Tinted Theming (https://github.com/tinted-theming)

export FZF_DEFAULT_OPTS=" \
  --history=$HOME/.fzfhistory \
  --layout=reverse \
  --color=fg:#e5e9f0,hl:#d08770\
  --color=fg+:#e5e9f0,hl+:#88c0d0\
  --color=info:#5e81ac,border:#81a1c1,prompt:#a3be8c\
  --color=pointer:#ebcb8b,marker:#a3be8c,spinner:#b48ead,header:#bf616a \
--pointer=❯ \
--multi"

_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=fg:#e5e9f0,hl:#d08770'
  '--color=fg+:#e5e9f0,hl+:#88c0d0'
  '--color=info:#5e81ac,border:#81a1c1,prompt:#a3be8c'
  '--color=pointer:#ebcb8b,marker:#a3be8c,spinner:#b48ead,header:#bf616a'
  '--pointer=❯'
  '--multi'
)