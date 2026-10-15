#!/usr/bin/env sh
# Toggle game mode (SUPER+F1): no animations, blur, shadow, gaps or rounding.
# Turning it off reloads the config, which restores your real values.
enabled=$(hyprctl getoption animations:enabled -j | jq -r .bool)

if [ "$enabled" = true ]; then
  hyprctl eval 'hl.config({
    animations = { enabled = false },
    decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
    general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
  })' >/dev/null
else
  hyprctl reload >/dev/null
fi
