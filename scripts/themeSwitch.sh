#!/bin/bash
DOCFONT="'Lexend 11'"
MONOFONT="'MesloLGS NF 10'"
FONT="'Lexend 11'"

if [ "$1" == "gruvbox" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/gruvbox.json
  flavours apply gruvbox-dark-hard
  echo 'export LS_COLORS="$(vivid generate gruvbox-dark-hard)"' >>~/.zshenv.zsh
  echo '--theme="gruvbox-dark"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Gruvbox'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Gruvbox/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "catppuccin-mocha" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/catppuccin-mocha.json
  flavours apply catppuccin-mocha
  echo 'export LS_COLORS="$(vivid generate catppuccin-mocha)"' >>~/.zshenv.zsh
  echo '--theme="catppuccin-mocha"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Catppuccin'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Catppuccin/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "dracula" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/dracula.json
  flavours apply dracula
  echo 'export LS_COLORS="$(vivid generate dracula)"' >>~/.zshenv.zsh
  echo '--theme="dracula"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Dracula'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Dracula/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "everforest" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/everforest.json
  echo 'export LS_COLORS="$(vivid generate ~/.config/vivid/themes/everforest.yaml)"' >>~/.zshenv.zsh
  echo '--theme="everforest-dark"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Everforest'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Everforest/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "nord" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/nord.json
  flavours apply nord
  echo 'export LS_COLORS="$(vivid generate nord)"' >>~/.zshenv.zsh
  echo '--theme="nord"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Nord'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Nord/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "rose-pine" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/rose-pine.json
  flavours apply rose-pine
  echo 'export LS_COLORS="$(vivid generate rose-pine)"' >>~/.zshenv.zsh
  echo '--theme="rose-pine"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'rose-pine-gtk'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/rose-pine-gtk/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "tokyo-night" ]; then
  # wal --theme ~/.config/wal/colorschemes/dark/tokyo-night.json
  flavours apply tokyo-night-moon
  echo 'export LS_COLORS="$(vivid generate tokyonight-moon)"' >>~/.zshenv.zsh
  echo '--theme="tokyonight-moon"' >>~/.config/bat/config
  dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
  dconf write /org/gnome/desktop/interface/font-name "$FONT"
  dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
  ln -sf /usr/share/themes/Tokyonight-Dark/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
fi

bat cache --build
