#!/usr/bin/env bash
export FZF_DEFAULT_OPTS=" \
--history=$HOME/.fzfhistory \
--layout=reverse \
--color=spinner:{color13},hl:{color1} \
--color=fg:{color7},header:{color9},info:{color12},pointer:{color13} \
--color=marker:{color4},fg+:{color7},prompt:{color12},hl+:{color1} \
--color=selected-bg:#45475a,border:{color10} \
--pointer=❯ \
--multi"
_FZF_TAB_FZF_FLAGS=(
  '--height=80%'
  '--layout=reverse'
  '--color=spinner:{color13},hl:{color1}'
  '--color=fg:{color7},header:{color9},info:{color12},pointer:{color13}'
  '--color=marker:{color4},fg+:{color7},prompt:{color12},hl+:{color1}'
  '--color=selected-bg:#45475a,border:{color10}'
  '--pointer=❯'
  '--multi'
)
