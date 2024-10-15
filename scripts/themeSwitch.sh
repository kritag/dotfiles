#!/bin/bash
if [ "$1" == "gruvbox" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/gruvbox.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Purple-Dark-Compact-Gruvbox'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Gruvbox/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "catppuccin-mocha" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/catppuccin-mocha.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Catppuccin'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Catppuccin/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "dracula" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/dracula.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Dracula'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Dracula/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "everforest" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/everforest.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Everforest'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Everforest/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "nord" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/nord.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Colloid-Dark-Compact-Nord'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Colloid-Dark-Compact-Nord/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "rose-pine" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/rose-pine.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'rose-pine-gtk'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/rose-pine-gtk/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
elif [ "$1" == "tokyo-night" ]; then
  wal --theme ~/.config/wal/colorschemes/dark/tokyo-night.json
  dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyonight-Dark'"
  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  ln -sf /usr/share/themes/Tokyonight-Dark/gtk-4.0/{assets,gtk.css,gtk-dark.css} ~/.config/gtk-4.0/
fi
