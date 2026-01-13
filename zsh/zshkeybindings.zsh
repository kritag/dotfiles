# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function setup_keybindings() {
    echoti smkx
    printf '\e[?12h\e[?25h'
    bindkey '^[[A' history-substring-search-up
    bindkey '^[OA' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^[OB' history-substring-search-down
    zle -N zle-line-init
    zle -N zle-line-finish

    # Remove precmd hook after first run to avoid repeating
    precmd_functions=(${precmd_functions:#setup_keybindings})
  }

  # Run the setup once before the first prompt is drawn
  precmd_functions+=(setup_keybindings)

  function zle-line-init() {
    echoti smkx
    printf '\e[?12h\e[?25h'
  }
  function zle-line-finish() {
    echoti rmkx
  }
fi

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word
# [Ctrl-W] - delete backward one word
bindkey -M emacs '^W' backward-delete-word
bindkey -M viins '^W' backward-delete-word
bindkey -M vicmd '^W' backward-delete-word
# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}" end-of-line
  bindkey -M viins "${terminfo[kend]}" end-of-line
  bindkey -M vicmd "${terminfo[kend]}" end-of-line
fi
# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi
# [Delete] - delete forward
bindkey -M emacs "^[[3~" delete-char
bindkey -M viins "^[[3~" delete-char
bindkey -M vicmd "^[[3~" delete-char
# Autosuggest accept suggestion
bindkey -M emacs '^ ' autosuggest-accept
bindkey -M viins '^ ' autosuggest-accept
bindkey -M vicmd '^ ' autosuggest-accept
# Make the zsh-vi plugin not overwrite fzf-history-widget in insert mode
function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
  # zvm_bindkey viins "^[OA" history-substring-search-up
  # zvm_bindkey viins "^[OB" history-substring-search-down
  # zvm_bindkey viins "^[[A" history-substring-search-up
  # zvm_bindkey viins "^[[B" history-substring-search-down
}
bindkey -v
