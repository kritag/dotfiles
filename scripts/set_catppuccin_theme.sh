#!/bin/sh
# Set theme in Gnome
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Mauve-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Catppuccin-Mocha-Standard-Mauve-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Catppuccin-Mocha-Mauve-Cursors"
gsettings set org.gnome.desktop.interface cursor-size 32
# Set theme for GTK 4.0
mkdir -p "${HOME}/.config/gtk-4.0"
ln -sf /usr/share/themes/catppuccin-mocha-mauve-standard+default/gtk-4.0/assets "${HOME}/.config/gtk-4.0/assets"
ln -sf /usr/share/themes/catppuccin-mocha-mauve-standard+default/gtk-4.0/gtk.css "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf /usr/share/themes/catppuccin-mocha-mauve-standard+default/gtk-4.0/gtk-dark.css "${HOME}/.config/gtk-4.0/gtk-dark.css"
