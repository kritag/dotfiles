#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: remove_intune.sh [--force] [--dry-run]

Options:
  --force    Skip confirmation prompt.
  --dry-run  Print actions without executing.
EOF
}

force=0
dry_run=0

for arg in "$@"; do
  case "$arg" in
  --force) force=1 ;;
  --dry-run) dry_run=1 ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $arg" >&2
    usage >&2
    exit 1
    ;;
  esac
done

run_cmd() {
  if ((dry_run)); then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

stop_unit() {
  local mode="$1"
  local unit="$2"
  if [[ "$mode" == "user" ]]; then
    run_cmd systemctl --user stop "$unit" || true
  elif [[ "$mode" == "system" ]]; then
    run_cmd sudo systemctl stop "$unit" || true
  else
    echo "Invalid mode: $mode" >&2
    exit 1
  fi
}

remove_home_path() {
  local path="$1"
  if [[ -z "$path" || "$path" == "/" || "$path" == "$HOME" ]]; then
    echo "Refusing to remove unsafe path: $path" >&2
    exit 1
  fi
  if [[ "$path" != "$HOME"/* ]]; then
    echo "Refusing to remove non-home path without sudo helper: $path" >&2
    exit 1
  fi
  run_cmd rm -rf -- "$path"
}

remove_root_path() {
  local path="$1"
  if [[ "$path" != "/var/lib/microsoft-identity-device-broker" ]]; then
    echo "Refusing to remove unexpected root path: $path" >&2
    exit 1
  fi
  run_cmd sudo rm -rf -- "$path"
}

if ((!force)); then
  echo "This will stop Intune services and delete Intune/Microsoft local state."
  read -r -p "Type YES to continue: " confirm
  if [[ "$confirm" != "YES" ]]; then
    echo "Aborted."
    exit 1
  fi
fi

stop_unit user microsoft-identity-broker.service
stop_unit user intune-agent.service
stop_unit user intune-agent.timer
stop_unit system microsoft-identity-device-broker.service
stop_unit system intune-daemon.socket
stop_unit system intune-daemon.service

home_paths=(
  "$HOME/.Microsoft"
  "$HOME/.cache/Microsoft"
  "$HOME/.cache/intune-portal"
  "$HOME/.cache/microsoft-edge"
  "$HOME/.config/intune"
  "$HOME/.config/microsoft-identity-broker"
  "$HOME/.local/share/intune-portal"
  "$HOME/.local/state/intune"
  "$HOME/.local/state/log/microsoft-identity-broker"
  "$HOME/.local/state/microsoft-identity-broker"
)

for path in "${home_paths[@]}"; do
  remove_home_path "$path"
done

remove_root_path "/var/lib/microsoft-identity-device-broker"

echo "Intune cleanup complete."
