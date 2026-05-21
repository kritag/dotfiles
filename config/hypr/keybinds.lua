local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

-- Apps / actions
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind("SUPER + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind("SUPER + G", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + G", function()
	hl.config({ general = { layout = "lua:grid" } })
end)
hl.bind("SUPER + SHIFT + M", function()
	hl.config({ general = { layout = "lua:manual" } })
end)
hl.bind("SUPER + SHIFT + D", function()
	hl.config({ general = { layout = "dwindle" } })
end)
-- manual layout messages (i3-like)
hl.bind("SUPER + minus", hl.dsp.layout("splith")) -- next window splits horizontally
hl.bind("SUPER + backslash", hl.dsp.layout("splitv")) -- next window splits vertically
-- Move focused window within the layout (grid: across/within columns)
hl.bind("SUPER + SHIFT + h", hl.dsp.layout("move-left"))
hl.bind("SUPER + SHIFT + j", hl.dsp.layout("move-down"))
hl.bind("SUPER + SHIFT + k", hl.dsp.layout("move-up"))
hl.bind("SUPER + SHIFT + l", hl.dsp.layout("move-right"))
-- Swap entire focused column with neighbor column
hl.bind("SUPER + CTRL + h", hl.dsp.layout("swap-col-left"))
hl.bind("SUPER + CTRL + l", hl.dsp.layout("swap-col-right"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm-app -- thunar.desktop"))
hl.bind("SUPER + CTRL + E", hl.dsp.exec_cmd('dms ipc call spotlight openQuery ":e "'))
hl.bind("SUPER + B", hl.dsp.exec_cmd("uwsm-app -- zen.desktop"))
hl.bind("SUPER + R", hl.dsp.exec_cmd(scriptsDir .. "/moveAllWorkspaces.sh"))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm-app -- kitty"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind("SUPER + F1", hl.dsp.exec_cmd(scriptsDir .. "/gamemode.sh"))
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd('uwsm-app -- kitty --class "kitty-floating"'))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("dms ipc call widget toggle launcherButton"))
hl.bind("ALT + return", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call widget toggle notificationButton"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))

-- Focus
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

-- Screenshots
local ssArea = scriptsDir .. "/screenshot.sh area ~/pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H%M%S).png"
local ssScreen = scriptsDir .. "/screenshot.sh screen ~/pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H%M%S).png"
hl.bind("Print", hl.dsp.exec_cmd(ssArea))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(ssScreen))
hl.bind("XF86SelectiveScreenshot", hl.dsp.exec_cmd(ssArea))
hl.bind("SHIFT + XF86SelectiveScreenshot", hl.dsp.exec_cmd(ssScreen))

-- Workspace navigation
hl.bind("SUPER + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

hl.bind("CTRL + ALT + SUPER + SHIFT + comma", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("CTRL + ALT + SUPER + SHIFT + period", hl.dsp.workspace.move({ monitor = "r" }))

-- Special workspace
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- 1-9 + 0 → workspace and move-to-workspace (silent variant on CTRL)
for i = 1, 9 do
	local k = tostring(i)
	hl.bind("SUPER + " .. k, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. k, hl.dsp.window.move({ workspace = k }))
	hl.bind("SUPER + CTRL + " .. k, hl.dsp.window.move({ workspace = k, follow = false }))
end
hl.bind("SUPER + 0", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind("SUPER + CTRL + 0", hl.dsp.window.move({ workspace = "10", follow = false }))

-- Media / brightness (locked + repeating)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%-"),
	{ locked = true, repeating = true }
)

-- Locked only
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- Scroll between workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + ALT_L", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + Control_L", hl.dsp.window.drag(), { mouse = true })

-- Resize active (repeating)
hl.bind("SUPER + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind("SUPER + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- Power
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"))
