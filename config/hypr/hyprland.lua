-- Rename to hyprland.lua to activate.
-- When hyprland.lua is present, Hyprland loads it instead of hyprland.conf.

-- Make the config dir importable so `require("monitors")` etc. work.
local home = os.getenv("HOME") or ""
local cfg  = (os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")) .. "/hypr"
package.path = cfg .. "/?.lua;" .. cfg .. "/?/init.lua;" .. package.path

require("monitors")
require("general")
require("decoration")
require("animations")
require("input")
require("layouts")
require("misc")
-- xdph.conf is read by xdg-desktop-portal-hyprland directly, not Hyprland.
-- It stays as hyprlang at ~/.config/hypr/xdph.conf.
require("windowrules")
require("keybinds")

-- autostart.lua is per-machine, linked by dotbot from
-- config/hypr-{workstation,desktop}/autostart.lua.
local ok = pcall(require, "autostart")
if not ok then
    print("[hypr] autostart.lua not found, skipping (run dotbot to link the machine-specific file)")
end
