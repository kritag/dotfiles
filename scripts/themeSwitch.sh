#!/usr/bin/env bash
DOCFONT="'Lexend 11'"
MONOFONT="'Nordwand Mono 11'"
FONT="'Lexend 11'"
STAMP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
STAMP_FILE="$STAMP_DIR/tinty-sync.done"

# name|tinty scheme|vivid|bat+delta|nvim colorscheme|zsh-patina|kitty theme|gtk theme|eza
THEMES='
gruvbox|gruvbox-dark-hard|gruvbox-dark-hard|gruvbox-dark|gruvbox|gruvbox-dark-hard|Gruvbox Material Dark Hard|Gruvbox-Dark-Compact|gruvbox-dark
catppuccin-mocha|catppuccin-mocha|catppuccin-mocha|catppuccin-mocha|catppuccin|catppuccin-mocha|Catppuccin-Mocha|Catppuccin-Dark-Compact|catppuccin-mocha
dracula|dracula|dracula|Dracula|dracula|dracula|Dracula|Dracula|dracula
everforest|everforest-dark-hard|~/.config/vivid/themes/everforest.yaml|everforest-dark|everforest|everforest-dark|Everforest Dark Hard|Everforest-Dark-Compact|everforest
nord|nord|nord|Nord|nord|nord|Nord|Nord-Dark-Compact-Nord|nord
rose-pine|rose-pine|rose-pine|rose-pine|rose-pine|rose-pine|Rosé Pine Moon|Rosepine-Dark-Compact|rose-pine
tokyo-night|tokyo-night-night|tokyonight-night|tokyonight-night|tokyonight|tokyonight-night|Tokyo Night|Tokyonight-Dark-Compact|tokyonight
'

found=
while IFS='|' read -r name tinty vivid bat nvim patina kitty gtk eza; do
  [[ -n "$name" && "$name" == "$1" ]] && found=1 && break
done <<<"$THEMES"

if [[ -z "$found" ]]; then
  echo "Invalid theme specified. Choose from: $(cut -d'|' -f1 <<<"${THEMES#$'\n'}" | paste -sd' ')" >&2
  exit 1
fi

if [[ ! -f "$STAMP_FILE" ]]; then
  tinty sync
  mkdir -p "$STAMP_DIR"
  : >"$STAMP_FILE"
fi

# Templates are built into gitignored output dirs, so rebuild before applying.
tinty build --quiet
tinty apply "base24-$tinty"

sed -i --follow-symlinks "s|\(vivid generate \)[^ ]*|\1$vivid|" ~/.zshenv
rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/ls_colors" # zshenv rebuilds it in new shells
sed -i --follow-symlinks "s/--theme=\"[^\"]*\"/--theme=\"$bat\"/" ~/.config/bat/config
sed -i --follow-symlinks "s/^[[:space:]]*syntax-theme[[:space:]]*=.*/  syntax-theme = $bat/" ~/.theme.gitconfig
sed -i --follow-symlinks "s/\(colorscheme = \"\)[^\"]*\(\",\)/\1$nvim\2/" ~/.config/lazyvim/lua/plugins/colorscheme.lua
sed -i --follow-symlinks "s|^theme = \"file:.*\"|theme = \"file:~/.config/zsh-patina/themes/$patina.toml\"|" ~/.config/zsh-patina/config.toml

read -ra kitty_args <<<"$kitty"
kitten themes "${kitty_args[@]}"

[[ "$1" == nord ]] && papirus-folders -C nordic --theme Papirus-Dark

dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk'"
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
dconf write /org/gnome/desktop/interface/document-font-name "$DOCFONT"
dconf write /org/gnome/desktop/interface/font-name "$FONT"
dconf write /org/gnome/desktop/interface/monospace-font-name "$MONOFONT"
ln -sf ~/.config/eza/"$eza".yaml ~/.config/eza/theme.yml

# GTK4/libadwaita ignores the gtk-theme gsetting: the theme is whatever
# ~/.config/gtk-4.0/gtk.css imports. Run this after the theme is set —
# gtk4-theme.sh reads it back, regenerates gtk.css (theme sheet, then
# sidebar-label-fix.css, which repairs the sidebar labels the *-Compact themes
# paint in the background colour) and relinks assets/gtk-dark.css.
GTK4_THEME="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")/gtk4-theme.sh"
GTK_THEME_NAME="$(dconf read /org/gnome/desktop/interface/gtk-theme | tr -d "'")"

if [[ ! -x "$GTK4_THEME" ]]; then
  echo "themeSwitch: $GTK4_THEME not executable; GTK4 apps keep the old theme" >&2
elif [[ -z "$GTK_THEME_NAME" ]]; then
  echo "themeSwitch: no gtk-theme set; skipping the GTK4 sidebar fix" >&2
else
  "$GTK4_THEME" --no-gsettings "$GTK_THEME_NAME" ||
    echo "themeSwitch: GTK4 theme '$GTK_THEME_NAME' not applied" >&2
fi

bat cache --build
zsh-patina restart
exec zsh
