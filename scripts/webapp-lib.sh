#!/usr/bin/env bash
# Shared logic for webapp-{zen,edge,firefox}. Sourced, never run directly.
#
# The sourcing script sets BROWSER (id) and LABEL (display name) and defines
#   webapp_preflight                   optional, checked before `create`
#   webapp_desktop_entry NAME URL ICON  prints the .desktop file body
# then calls: webapp_main "$@"

DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/webapps"

slugify() {
  echo "$1" |
    tr '[:upper:]' '[:lower:]' |
    tr -cs 'a-z0-9' '-' |
    sed 's/^-*//; s/-*$//'
}

# quote a value for a .desktop Exec line
exec_quote() {
  local s="${1//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//\`/\\\`}"
  s="${s//\$/\\\$}"
  printf '"%s"' "${s//%/%%}"
}

fetch_icon() {
  local domain="$1" icon_png="$2"
  local tmp_ico="${icon_png}.tmp.ico"

  [[ -f "$icon_png" ]] && return 0

  if curl -fsSL "https://icons.duckduckgo.com/ip3/${domain}.ico" -o "$tmp_ico"; then
    magick "${tmp_ico}[0]" "$icon_png"
    rm -f "$tmp_ico"
    return 0
  fi

  return 1
}

create_webapp() {
  local name="$1" url="$2" slug domain
  slug=$(slugify "$name")
  local desktop_file="$DESKTOP_DIR/webapp-$BROWSER-$slug.desktop"
  local icon_file="$ICON_DIR/$BROWSER-$slug.png"

  declare -F webapp_preflight >/dev/null && webapp_preflight
  mkdir -p "$DESKTOP_DIR" "$ICON_DIR"

  echo "→ Creating $LABEL WebApp: $name"

  domain=$(echo "$url" | awk -F/ '{print $3}')
  if fetch_icon "$domain" "$icon_file"; then
    echo "  Saved icon: $icon_file"
  else
    echo "  No icon found."
  fi

  webapp_desktop_entry "$name" "$url" "$icon_file" >"$desktop_file"
  echo "✓ Created $desktop_file"
}

remove_webapp() {
  local slug
  slug=$(slugify "$1")

  echo "→ Removing $LABEL WebApp: $1"
  rm -f "$DESKTOP_DIR/webapp-$BROWSER-$slug.desktop" "$ICON_DIR/$BROWSER-$slug.png"
  echo "✓ Removed."
}

list_webapps() {
  local f found=0
  echo "$LABEL WebApps:"
  shopt -s nullglob
  for f in "$DESKTOP_DIR"/webapp-"$BROWSER"-*.desktop; do
    f="${f##*/webapp-$BROWSER-}"
    echo "  ${f%.desktop}"
    found=1
  done
  ((found)) || echo "  (none)"
}

usage() {
  local cmd="webapp-$BROWSER"
  echo "Usage:"
  echo "  $cmd create \"Name\" https://url"
  echo "  $cmd remove \"Name\""
  echo "  $cmd list"
  exit 1
}

webapp_main() {
  case "${1:-}" in
  create)
    [[ $# -eq 3 ]] || usage
    create_webapp "$2" "$3"
    ;;
  remove)
    [[ $# -eq 2 ]] || usage
    remove_webapp "$2"
    ;;
  list) list_webapps ;;
  *) usage ;;
  esac
}
