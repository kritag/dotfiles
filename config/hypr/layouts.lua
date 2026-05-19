hl.config({
	dwindle = {
		force_split = 2,
		permanent_direction_override = true,
		preserve_split = true,
		smart_resizing = false,
		split_width_multiplier = 0.5,
	},
	master = {
		mfact = 0.33,
		new_status = "slave",
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
