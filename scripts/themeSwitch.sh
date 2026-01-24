#!/bin/env bash
DOCFONT="'Rubik 11'"
MONOFONT="'Meslo LG S 10'"
FONT="'Rubik 11'"

case "$1" in
"gruvbox")
  flavours apply gruvbox-dark-hard
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1gruvbox-dark-hard/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="gruvbox-dark"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = gruvbox-dark/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1gruvbox\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/gruvbox.ini.ini" >~/.config/fsh/current-theme
  kitten themes Gruvbox Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Gruvbox-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Everforest-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Gruvbox-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ln -sf ~/.config/eza/gruvbox-dark.yml ~/.config/eza/theme.yml
  ;;

"catppuccin-mocha")
  flavours apply catppuccin-mocha
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1catppuccin-mocha/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="catppuccin-mocha"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = catppuccin-mocha/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1catppuccin\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/catppuccin-mocha.ini" >~/.config/fsh/current-theme
  kitten themes Catppuccin-Mocha
  dconf write /org/gnome/desktop/interface/gtk-theme "'Catppuccin-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Catppuccin-Mocha'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Catppuccin-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ln -sf ~/.config/eza/catppuccin-mocha.yml ~/.config/eza/theme.yml
  ;;

"dracula")
  flavours apply dracula
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1dracula/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="Dracula"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = Dracula/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1dracula\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/dracula.ini" >~/.config/fsh/current-theme
  kitten themes Dracula
  dconf write /org/gnome/desktop/interface/gtk-theme "'Dracula'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Dracula'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Dracula/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ln -sf ~/.config/eza/dracula.yml ~/.config/eza/theme.yml
  ;;

"everforest")
  flavours apply everforest-dark-hard
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1~\/.config\/vivid\/themes\/everforest.yaml/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="everforest-dark"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = everforest-dark/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1everforest\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/everforest.ini" >~/.config/fsh/current-theme
  kitten themes Everforest Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Everforest-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Everforest-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Everforest-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  # ln -sf ~/.config/eza/ ~/.config/eza/theme.yml
  ;;

"nord")
  flavours apply nord
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1nord/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="Nord"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = Nord/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1nord\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/nord.ini" >~/.config/fsh/current-theme
  kitten themes Nord
  papirus-folders -C nordic --theme Papirus-Dark
  dconf write /org/gnome/desktop/interface/gtk-theme "'Nord-Dark-Compact-Nord'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Nord-Nord-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Nord-Dark-Compact-Nord/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  # ln -sf ~/.config/eza/catppuccin-mocha.yml ~/.config/eza/theme.yml
  ;;

"rose-pine")
  flavours apply rose-pine
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1rose-pine/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="rose-pine"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = rose-pine/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1rose-pine\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/rose-pine.ini" >~/.config/fsh/current-theme
  kitten themes Rosé Pine Moon
  dconf write /org/gnome/desktop/interface/gtk-theme "'Rosepine-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Rose-Pine'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Rosepine-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ln -sf ~/.config/eza/rose-pine.yml ~/.config/eza/theme.yml
  ;;

"tokyo-night")
  flavours apply tokyo-night-night
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1tokyonight-moon/' ~/.zshenv
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="tokyonight-moon"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/^ *syntax-theme *=.*/  syntax-theme = tokyonight-moon/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1tokyonight\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  echo "$HOME/.config/fsh/tokyo-night-moon.ini" >~/.config/fsh/current-theme
  kitten themes Tokyo Night Moon
  dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/icon-theme "'Tokyonight-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Tokyonight-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ln -sf ~/.config/eza/tokyonight.yml ~/.config/eza/theme.yml
  ;;

*)
  echo "Invalid theme specified."
  ;;
esac

bat cache --build
exec zsh
