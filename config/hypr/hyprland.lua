-- Layouts must register before any hl.config() call references them by name,
-- otherwise Hyprland can't bind workspaces to a not-yet-registered layout.
require("layout_columns")
require("layout_manual")
require("layout_grid")

require("autostart")
require("monitors")
require("general")
require("decoration")
require("animations")
require("input")
require("layouts")
require("misc")
require("windowrules")
require("keybinds")
