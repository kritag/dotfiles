#!/usr/bin/env bash
# themeSwitch.sh <theme>           workstation/desktop: every tool in $HOME, GTK and kitty included
# themeSwitch.sh --server <theme>  server, run as the repo owner: writes only .server-generated/, shared by all users
DOCFONT="'Geist 11'"
MONOFONT="'Geist Mono 11'"
FONT="'Geist 11'"
# Family name only (no size), for templates that set font-family; read by tinty hooks.
export TINTY_FONT="$(tr -d "'" <<<"$FONT" | sed -E 's/ [0-9.]+$//')"
export TINTY_MONOFONT="$(tr -d "'" <<<"$MONOFONT" | sed -E 's/ [0-9.]+$//')"
TINTY_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/tinted-theming/tinty"

server=; [[ ${1:-} == --server ]] && { server=1; shift; }

# Per theme: tinty scheme, vivid, bat+delta, nvim, zsh-patina, kitty, gtk, eza, dms (theme id, installed by bootstrap-dms-themes.sh)
case "$1" in
gruvbox)
  tinty=gruvbox-dark-hard vivid=gruvbox-dark-hard bat=gruvbox-dark nvim=gruvbox patina=gruvbox-dark-hard
  kitty="Gruvbox Material Dark Hard" gtk=Gruvbox-Dark-Compact eza=gruvbox-dark dms=gruvboxMaterial ;;
catppuccin-mocha)
  tinty=catppuccin-mocha vivid=catppuccin-mocha bat=catppuccin-mocha nvim=catppuccin patina=catppuccin-mocha
  kitty=Catppuccin-Mocha gtk=Catppuccin-Dark-Compact eza=catppuccin-mocha dms=catppuccin ;;
dracula)
  tinty=dracula vivid=dracula bat=Dracula nvim=dracula patina=dracula
  kitty=Dracula gtk=Dracula eza=dracula dms=dracula ;;
everforest)
  tinty=everforest-dark-hard vivid='~/.config/vivid/themes/everforest.yaml' bat=everforest-dark nvim=everforest patina=everforest-dark
  kitty="Everforest Dark Hard" gtk=Everforest-Dark-Compact eza=everforest dms=everforest ;;
nord)
  tinty=nord vivid=nord bat=Nord nvim=nord patina=nord
  kitty=Nord gtk=Nord-Dark-Compact-Nord eza=nord dms=nord ;;
rose-pine)
  tinty=rose-pine vivid=rose-pine bat=rose-pine nvim=rose-pine patina=rose-pine
  kitty="Rosé Pine Moon" gtk=Rosepine-Dark-Compact eza=rose-pine dms=rosePine ;;
tokyo-night)
  tinty=tokyo-night-night vivid=tokyonight-night bat=tokyonight-night nvim=tokyonight patina=tokyonight-night
  kitty="Tokyo Night" gtk=Tokyonight-Dark-Compact eza=tokyonight dms=tokyoNight ;;
*)
  echo "Invalid theme specified. Choose from: gruvbox catppuccin-mocha dracula everforest nord rose-pine tokyo-night" >&2
  exit 1 ;;
esac

if [[ $server ]]; then
  set -euo pipefail
  repo="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
  gen="$repo/.server-generated"
  mkdir -p "$gen/eza"
  sed "s|@REPO@|$repo|g" "$repo/config/tinty-server.toml" >"$gen/tinty.toml"
  tinty_server() { tinty --config "$gen/tinty.toml" --data-dir "$gen/tinty-data" "$@" </dev/null; }
  [[ -d $gen/tinty-data/scheme-repos ]] || tinty_server sync >/dev/null
  tinty_server build --quiet
  tinty_server apply "base24-$tinty" >/dev/null

  ln -sfn "$repo/config/eza/$eza.yaml" "$gen/eza/theme.yml"
  cat >"$gen/theme.zsh" <<EOF
export BAT_THEME="$bat" EZA_CONFIG_DIR="$gen/eza"
export LS_COLORS="\$(vivid generate ${vivid/#\~\/.config\/vivid/$repo/config/vivid})"
EOF
  echo "$1" >"$gen/theme"
  echo "server theme: $1"
  exit
fi

# First run on a machine: fetch the scheme and template repos.
[[ -d "$TINTY_DATA/scheme-repos" ]] || tinty sync

# Templates are built into gitignored output dirs, so rebuild before applying.
tinty build --quiet
tinty apply "base24-$tinty"

# sub FILE WANTED SED_EXPR: run sed, then warn if WANTED is missing (the pattern stopped matching).
sub() {
  sed -i --follow-symlinks "$3" "$1"
  grep -qF -- "$2" "$1" || echo "themeSwitch: $1 not updated, sed pattern no longer matches" >&2
}

sub ~/.zshrc "_vivid_theme=$vivid" "s|^\(_vivid_theme=\).*|\1$vivid|"
rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/ls_colors" # zshrc rebuilds it in new shells
sub ~/.config/bat/config "--theme=\"$bat\"" "s/--theme=\"[^\"]*\"/--theme=\"$bat\"/"
sub ~/.theme.gitconfig "syntax-theme = $bat" "s/^[[:space:]]*syntax-theme[[:space:]]*=.*/  syntax-theme = $bat/"
sub ~/.config/lazyvim/lua/plugins/colorscheme.lua "colorscheme = \"$nvim\"" "s/\(colorscheme = \"\)[^\"]*\(\",\)/\1$nvim\2/"
sub ~/.config/zsh-patina/config.toml "themes/$patina.toml" "s|^theme = \"file:.*\"|theme = \"file:~/.config/zsh-patina/themes/$patina.toml\"|"
sub ~/.config/dms/settings.json "themes/$dms/theme.json" "s|\"customThemeFile\": \"[^\"]*\"|\"customThemeFile\": \"~/.config/dms/themes/$dms/theme.json\"|"
# DMS fonts: top-level keys sit at 2-space indent; the nested fontFamily keys are the lock screen/greeter clocks (mono).
sub ~/.config/dms/settings.json "\"fontFamily\": \"$TINTY_FONT\"" "s#^\(  \"\(fontFamily\|displayFontFamily\|lockScreenFontFamily\)\": \"\)[^\"]*#\1$TINTY_FONT#"
sub ~/.config/dms/settings.json "\"monoFontFamily\": \"$TINTY_MONOFONT\"" "s|^\(  \"monoFontFamily\": \"\)[^\"]*|\1$TINTY_MONOFONT|; s|^\(   \+\"fontFamily\": \"\)[^\"]*|\1$TINTY_MONOFONT|"

# Fonts: kitty (nvim follows it) and fontconfig's sans-serif/monospace aliases.
sed -i --follow-symlinks "s|^font_family .*|font_family      family=\"$TINTY_MONOFONT\"|" ~/.config/kitty/kitty.conf
perl -0pi -e "s|(<family>sans-serif</family>\s*<prefer>\s*<family>)[^<]*|\${1}$TINTY_FONT|; s|(<family>monospace</family>\s*<prefer>\s*<family>)[^<]*|\${1}$TINTY_MONOFONT|" "$(readlink -f ~/.config/fontconfig/fonts.conf)"

read -ra kitty_args <<<"$kitty"
kitten themes "${kitty_args[@]}"
pkill -USR1 -x kitty || true # reload config, picks up the font

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
# DOTFILES_BOOTSTRAP: called from ./install, where there is no terminal to replace
if [[ -z ${DOTFILES_BOOTSTRAP:-} ]]; then exec zsh; fi
