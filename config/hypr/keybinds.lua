local mainMod = "SUPER"
local fileManager = "uwsm-app -- thunar.desktop"
local terminal = "uwsm-app -- kitty.desktop"
local browser = "uwsm-app -- zen.desktop"
local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

local function exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end
local function bind(keys, action, opts)
	return hl.bind(keys, action, opts)
end

-- Apps / actions
bind(mainMod .. " + Q", hl.dsp.window.close())
bind(mainMod .. " + M", exec("uwsm stop"))
bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
bind(mainMod .. " + G", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + E", exec(fileManager))
bind(mainMod .. " + CTRL + E", exec('dms ipc call spotlight openQuery ":e "'))
bind(mainMod .. " + B", exec(browser))
bind(mainMod .. " + R", exec(scriptsDir .. "/moveAllWorkspaces.sh"))
bind(mainMod .. " + RETURN", exec("kitty"))
bind(mainMod .. " + SHIFT + L", exec("dms ipc call lock lock"))
bind(mainMod .. " + SHIFT + W", exec("dms ipc call dankdash wallpaper"))
bind(mainMod .. " + F1", exec(scriptsDir .. "/gamemode.sh"))
bind(mainMod .. " + ALT + RETURN", exec('uwsm-app -- kitty --class "kitty-floating"'))
bind(mainMod .. " + SHIFT + C", exec("hyprctl reload"))
bind(mainMod .. " + SUPER_L", exec("dms ipc call widget toggle launcherButton"))
bind("ALT + return", hl.dsp.window.fullscreen({ action = "toggle" }))
bind(mainMod .. " + N", exec("dms ipc call widget toggle notificationButton"))
bind(mainMod .. " + V", exec("dms ipc call clipboard toggle"))

-- Focus
bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Screenshots
local function ssArea()
	return exec(scriptsDir .. "/screenshot.sh area ~/pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H%M%S).png")
end
local function ssScreen()
	return exec(scriptsDir .. "/screenshot.sh screen ~/pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H%M%S).png")
end
bind("Print", ssArea())
bind("SHIFT + Print", ssScreen())
bind("XF86SelectiveScreenshot", ssArea())
bind("SHIFT + XF86SelectiveScreenshot", ssScreen())

-- Workspace navigation
bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))
bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

bind("CTRL + ALT + " .. mainMod .. " + SHIFT + comma", hl.dsp.workspace.move({ monitor = "l" }))
bind("CTRL + ALT + " .. mainMod .. " + SHIFT + period", hl.dsp.workspace.move({ monitor = "r" }))

-- Special workspace
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- 1-9 + 0 → workspace and move-to-workspace (silent variant on CTRL)
for i = 1, 9 do
	local k = tostring(i)
	bind(mainMod .. " + " .. k, hl.dsp.focus({ workspace = i }))
	bind(mainMod .. " + SHIFT + " .. k, hl.dsp.window.move({ workspace = tostring(i) }))
	bind(mainMod .. " + CTRL + " .. k, hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end
bind(mainMod .. " + 0", hl.dsp.window.move({ workspace = "r+1" }))
bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
bind(mainMod .. " + CTRL + 0", hl.dsp.window.move({ workspace = "10", follow = false }))

-- Media / brightness (bindle in hyprlang = locked + repeating)
bind("XF86MonBrightnessUp", exec("brightnessctl set +5%"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { locked = true, repeating = true })
bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"),
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioLowerVolume",
	exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%-"),
	{ locked = true, repeating = true }
)

-- bindl in hyprlang = locked only
bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- Scroll between workspaces
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize (bindm)
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + ALT_L", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + Control_L", hl.dsp.window.drag(), { mouse = true })

-- Resize active (binde = repeating)
bind(mainMod .. " + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
bind(mainMod .. " + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
bind(mainMod .. " + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
bind(mainMod .. " + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

-- Power
bind("XF86PowerOff", exec("systemctl suspend"))
