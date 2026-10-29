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
			enabled = true,
			size = 10,
			passes = 2,
			new_optimizations = true,
			ignore_opacity = true,
			-- variant = "acrylic",
			-- acrylic = { tint = "rgba(a7c08014)" },
			-- aurora = { color1 = "rgba(a7c08029)", color2 = "rgba(7fbbb37a)" },
			-- fluid_jar = { color = "rgba(a7c080cc)" },
		},
	},
})
