local colors = require("colors")

hl.config({
	general = {
		allow_tearing = true,
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		layout = "lua:grid",
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
