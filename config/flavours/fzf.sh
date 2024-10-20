# -Gruvbox dark, hard
# Scheme author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
# Template author: Tinted Theming (https://github.com/tinted-theming)

export FZF_DEFAULT_OPTS=" \
  --history=$HOME/.fzfhistory \
  --layout=reverse \
  --color=bg:#1d2021,fg:#d5c4a1,hl:#fe8019\
  --color=bg+:#504945,fg+:#d5c4a1,hl+:#8ec07c\
  --color=info:#d65d0e,border:#83a598,prompt:#b8bb26\
  --color=pointer:#1d2021,marker:#b8bb26,spinner:#d3869b,header:#fb4934 \
--pointer=❯ \
--multi"

_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=bg:#1d2021,fg:#d5c4a1,hl:#fe8019'
  '--color=bg+:#504945,fg+:#d5c4a1,hl+:#8ec07c'
  '--color=info:#d65d0e,border:#83a598,prompt:#b8bb26'
  '--color=pointer:#1d2021,marker:#b8bb26,spinner:#d3869b,header:#fb4934'
  '--pointer=❯'
  '--multi'
)