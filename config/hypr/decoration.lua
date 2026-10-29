local colors = require("colors")

hl.config({
	decoration = {
		active_opacity = 1,
		inactive_opacity = 1,
		rounding = 12,
		glow = {
			enabled = true,
			range = 5,
			color = { colors = { colors.base0B, colors.base0D }, angle = 45 },
			color_inactive = { colors = { colors.base02, colors.base01 }, angle = 75 },
		},
		blur = {
			size = 10,
			passes = 2,
		},
	},
})
