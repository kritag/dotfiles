hl.config({
	input = {
		accel_profile = "flat",
		follow_mouse = 1,
		force_no_accel = true,
		kb_layout = "us",
		kb_options = "caps:escape_shifted_capslock",
		kb_variant = "altgr-intl",
		repeat_delay = 200,
		repeat_rate = 30,
		scroll_factor = 1.5,
		sensitivity = 0.0,
		touchpad = {
			natural_scroll = false,
			scroll_factor = 1.0,
			disable_while_typing = true,
			clickfinger_behavior = true,
		},
	},
})
-- Scroll nicely in the terminal.
hl.window_rule({ match = { class = "^(Alacritty|kitty|foot)$" }, scroll_touchpad = 1.5 })
hl.window_rule({ match = { class = "^(com\\.mitchellh\\.ghostty)$" }, scroll_touchpad = 0.2 })
