#!/usr/bin/env bash
set -euo pipefail

PROFILE_NAME="WebApps"
FIREFOX_BIN="${FIREFOX_BIN:-firefox}"

# Detect Firefox config base directory
if [[ -d "$HOME/.config/mozilla/firefox" ]]; then
  FF_BASE="$HOME/.config/mozilla/firefox"
elif [[ -d "$HOME/.mozilla/firefox" ]]; then
  FF_BASE="$HOME/.mozilla/firefox"
else
  echo "ERROR: Firefox config directory not found."
  exit 1
fi

PROFILES_INI="$FF_BASE/profiles.ini"

echo "→ Ensuring profile '$PROFILE_NAME' exists..."

# This is safe even if profile already exists
"$FIREFOX_BIN" -CreateProfile "$PROFILE_NAME" >/dev/null 2>&1 || true

# Extract profile directory from profiles.ini
PROFILE_REL_PATH="$(
  awk -v profile="$PROFILE_NAME" '
    $0 ~ /^\[Profile/ {found=0}
    $0 ~ "^Name="profile"$" {found=1}
    found && $0 ~ /^Path=/ {
        sub(/^Path=/,"")
        print
        exit
    }
' "$PROFILES_INI"
)"

if [[ -z "$PROFILE_REL_PATH" ]]; then
  echo "ERROR: Could not locate profile path in profiles.ini"
  exit 1
fi

# Convert to absolute path if needed
if [[ "$PROFILE_REL_PATH" != /* ]]; then
  PROFILE_PATH="$FF_BASE/$PROFILE_REL_PATH"
else
  PROFILE_PATH="$PROFILE_REL_PATH"
fi

echo "→ Using profile directory: $PROFILE_PATH"

mkdir -p "$PROFILE_PATH/chrome"

# Install userChrome.css (idempotent overwrite)
cat >"$PROFILE_PATH/chrome/userChrome.css" <<'EOF'
/* ---- Firefox WebApp Minimal Mode ---- */

#TabsToolbar,
#nav-bar,
#PersonalToolbar,
#statuspanel,
#sidebar-box {
  visibility: collapse !important;
}

#titlebar {
  visibility: collapse !important;
}

:root[sizemode="normal"] #toolbar-menubar {
  visibility: collapse !important;
}
#toolbar-menubar[autohide="false"] {
  visibility: visible !important;
}
EOF

echo "  Installed userChrome.css"

# Install persistent preferences via user.js
cat >"$PROFILE_PATH/user.js" <<'EOF'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
EOF

echo "  Installed user.js"

echo "✓ Firefox WebApps profile ready."
