#!/bin/bash
DOCFONT="'Lexend 11'"
MONOFONT="'MesloLGS NF 10'"
FONT="'Lexend 11'"

if [ "$1" == "gruvbox" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/gruvbox.json
  flavours apply gruvbox-dark-hard
  sed -i 's/\(vivid generate \)[^)]*/\1gruvbox-dark-hard/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="gruvbox-dark"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1gruvbox-dark/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1gruvbox\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/gruvbox.ini
  kitten themes Gruvbox Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Gruvbox'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Gruvbox/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "catppuccin-mocha" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/catppuccin-mocha.json
  flavours apply catppuccin-mocha
  sed -i 's/\(vivid generate \)[^)]*/\1catppuccin-mocha/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="catppuccin-mocha"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1catppuccin-mocha/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1catppuccin\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/catppuccin-mocha.ini
  kitten themes Catppuccin-Mocha
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Catppuccin'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Catppuccin/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "dracula" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/dracula.json
  flavours apply dracula
  sed -i 's/\(vivid generate \)[^)]*/\1dracula/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="dracula"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1Dracula/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1dracula\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/dracula.ini
  kitten themes dracula
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Dracula'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Dracula/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "everforest" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/everforest.json
  flavours apply dracula
  sed -i 's/\(vivid generate \)[^)]*/\1~\/.config\/vivid\/themes\/everforest.yaml/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="everforest-dark"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1everforest-dark/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1everforest\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/everforest.ini
  kitten themes Everforest Dark Hard
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Everforest'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Everforest/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "nord" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/nord.json
  flavours apply nord
  sed -i 's/\(vivid generate \)[^)]*/\1nord/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="nord"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1Nord/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1nord\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/nord.ini
  kitten themes nord
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Nord'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Nord/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "rose-pine" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/rose-pine.json
  flavours apply rose-pine
  sed -i 's/\(vivid generate \)[^)]*/\1rose-pine/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="rose-pine"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1rose-pine/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1rose-pine\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/rose-pine.ini
  kitten themes Rosé Pine
  dconf write /org/gnome/desktop/interface/gtk-theme "'rose-pine-gtk'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/rose-pine-gtk/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "tokyo-night" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/tokyo-night.json
  flavours apply tokyo-night-moon
  sed -i 's/\(vivid generate \)[^)]*/\1tokyonight-moon/' ~/.zshenv.zsh
  sed -i 's/--theme="[^"]*"/--theme="tokyonight-moon"/' ~/.config/bat/config
  sed -i 's/\(syntax-style = \)[^ ]*/\1tokyonight-moon/' ~/.theme.gitconfig
  sed -i 's/\(colorscheme = "\)[^"]*\(",\)/\1tokyonight\2/' ~/.config/lazyvim/lua/plugins/colorscheme.lua
  fast-theme ~/.config/fsh/tokyo-night-moon.ini
  kitten themes Tokyo Night
  dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Dark-Compact'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Tokyonight-Dark-Compact/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
fi

bat cache --build
