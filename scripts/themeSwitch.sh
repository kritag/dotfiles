#!/bin/env bash
DOCFONT="'Rubik 11'"
MONOFONT="'Meslo LG S 10'"
FONT="'Rubik 11'"

case "$1" in
"gruvbox")
  flavours apply gruvbox-dark-hard
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1gruvbox-dark-hard/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="gruvbox-dark"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1gruvbox-dark/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1gruvbox\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Colloid-Dark-Compact-Gruvbox"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/gruvbox.ini
  kitten themes Gruvbox Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Gruvbox'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Gruvbox/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"catppuccin-mocha")
  flavours apply catppuccin-mocha
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1catppuccin-mocha/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="catppuccin-mocha"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1catppuccin-mocha/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1catppuccin\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Colloid-Dark-Compact-Catppuccin"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/catppuccin-mocha.ini
  kitten themes Catppuccin-Mocha
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Catppuccin'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Catppuccin/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"dracula")
  flavours apply dracula
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1dracula/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="dracula"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1Dracula/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1dracula\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Colloid-Dark-Compact-Dracula"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/dracula.ini
  kitten themes dracula
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Dracula'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Dracula/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"everforest")
  flavours apply everforest-dark-hard
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1~\/.config\/vivid\/themes\/everforest.yaml/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="everforest-dark"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1everforest-dark/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1everforest\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Colloid-Dark-Compact-Everforest"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/everforest.ini
  kitten themes Everforest Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Everforest'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Everforest/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"nord")
  flavours apply nord
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1nord/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="Nord"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1Nord/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1nord\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Colloid-Dark-Compact-Nord"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/nord.ini
  kitten themes nord
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Nord'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Nord/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"rose-pine")
  flavours apply rose-pine
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1rose-pine/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="rose-pine"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1rose-pine/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1rose-pine\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"rose-pine-gtk"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/rose-pine.ini
  kitten themes Rosé Pine
  dconf write /org/gnome/desktop/interface/gtk-theme "'rose-pine-gtk'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/rose-pine-gtk/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

"tokyo-night")
  flavours apply tokyo-night-moon
  sed -i --follow-symlinks 's/\(vivid generate \)[^)]*/\1tokyonight-moon/' ~/.zshenv.zsh
  sed -i --follow-symlinks 's/--theme="[^"]*"/--theme="tokyonight-moon"/' ~/.config/bat/config
  sed -i --follow-symlinks 's/\(syntax-theme = \)[^ ]*/\1tokyonight-moon/' ~/.theme.gitconfig
  sed -i --follow-symlinks 's/\(colorscheme = "\)[^"]*\(",\)/\1tokyonight\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  sed -i --follow-symlinks 's/^\($THEME\s*=\s*\).*$/\1"Tokyonight-Dark-Compact"/' ~/.config/hypr/env.conf
  fast-theme ~/.config/fsh/tokyo-night-moon.ini
  kitten themes Tokyo Night
  dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Tokyonight-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
  ;;

*)
  echo "Invalid theme specified."
  ;;
esac

bat cache --build
