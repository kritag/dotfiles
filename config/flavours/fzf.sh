# -Rosé Pine
# Scheme author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
# Template author: Tinted Theming (https://github.com/tinted-theming)

export FZF_DEFAULT_OPTS=" \
  --history=$HOME/.fzfhistory \
  --layout=reverse \
  --color=fg:#e0def4,hl:#f6c177\
  --color=fg+:#e0def4,hl+:#9ccfd8\
  --color=info:#524f67,border:#c4a7e7,prompt:#31748f\
  --color=pointer:#ebbcba,marker:#31748f,spinner:#f6c177,header:#eb6f92 \
--pointer=❯ \
--multi"

_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=fg:#e0def4,hl:#f6c177'
  '--color=fg+:#e0def4,hl+:#9ccfd8'
  '--color=info:#524f67,border:#c4a7e7,prompt:#31748f'
  '--color=pointer:#ebbcba,marker:#31748f,spinner:#f6c177,header:#eb6f92'
  '--pointer=❯'
  '--multi'
)