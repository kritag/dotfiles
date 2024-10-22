# -Tokyo night moon
# Scheme author: Ólafur Bjarki Bogason
# Template author: Tinted Theming (https://github.com/tinted-theming)

export FZF_DEFAULT_OPTS=" \
  --history=$HOME/.fzfhistory \
  --layout=reverse \
  --color=bg:#222436,fg:#3b4261,hl:#ffc777\
  --color=bg+:#2d3f76,fg+:#3b4261,hl+:#86e1fc\
  --color=info:#c53b53,border:#82aaff,prompt:#c3e88d\
  --color=pointer:#222436,marker:#c3e88d,spinner:#fca7ea,header:#ff757f \
--pointer=❯ \
--multi"

_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=bg:#222436,fg:#3b4261,hl:#ffc777'
  '--color=bg+:#2d3f76,fg+:#3b4261,hl+:#86e1fc'
  '--color=info:#c53b53,border:#82aaff,prompt:#c3e88d'
  '--color=pointer:#222436,marker:#c3e88d,spinner:#fca7ea,header:#ff757f'
  '--pointer=❯'
  '--multi'
)