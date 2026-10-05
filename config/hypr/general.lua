local colors = require("colors")

-- Layout chosen at runtime (scripts/layout.sh) survives reloads and restarts.
local function saved_layout()
	local f = io.open((os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/hypr-layout")
	if not f then
		return "dwindle"
	end
	local name = f:read("*l")
	f:close()
	return name and name ~= "" and name or "dwindle"
end

hl.config({
	general = {
		allow_tearing = true,
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		layout = saved_layout(),
		resize_on_border = false,
		col = {
			active_border = { colors = { colors.base0F, colors.base0C }, angle = 45 },
			inactive_border = { colors = { colors.base02, colors.base01 }, angle = 75 },
		},
		snap = {
			enabled = true,
		},
	},
})
