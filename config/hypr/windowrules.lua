hl.window_rule({
	name = "opacity-90",
	match = {
		class = "^(spotify|org.gnome.Calculator|org.gnome.Nautilus|org.kde.dolphin|steam|discord|Thunar|thunar|net.lutris.Lutris|org.gnome.Calendar|pcmanfm|Rofi|xdg-desktop-portal-gtk|org.qbittorrent.qBittorrent)$",
	},
	opacity = "0.90 0.90",
})

hl.window_rule({
	name = "float-modals",
	match = { modal = true },
	float = true,
})

hl.window_rule({
	name = "float-apps",
	match = {
		class = "^(org.gnome.Calculator|org.gnome.TextEditor|org.gnome.Loupe|org.gnome.font-viewer|org.gnome.Calendar|org.kde.dolphin|org.gnome.Nautilus|Thunar|thunar|Keybase|Rofi|org.quickshell|one.alynx.showmethekey|showmethekey-gtk|com.vysp3r.ProtonPlus|xdg-desktop-portal-gtk)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "steam",
	match = { class = "^(steam|.*\\.exe|steam_app)$" },
	immediate = true,
	idle_inhibit = "fullscreen",
	min_size = "1 1",
	workspace = "2 silent",
	float = true,
})

hl.window_rule({
	name = "lutris",
	match = { class = "^(net\\.lutris\\.Lutris)$" },
	workspace = "2 silent",
	float = true,
	size = "(monitor_w*0.49) (monitor_h*0.95)",
	move = "20 60",
})

hl.window_rule({
	name = "work",
	match = { class = "^(Slack|slack|microsoft-edge)$" },
	workspace = "2 silent",
})

hl.window_rule({
	name = "qbittorrent",
	match = { class = "^(org.qbittorrent.qBittorrent)$" },
	workspace = "5 silent",
})

hl.window_rule({
	name = "edge-apps",
	match = { class = "^(msedge-.*)$" },
	workspace = "3 silent",
})

hl.window_rule({
	name = "spotify",
	match = { class = "^(spotify|Spotify)$" },
	workspace = "4 silent",
	float = true,
	center = true,
	size = "(monitor_w*0.4) (monitor_h*0.7)",
})

hl.window_rule({
	name = "Thunar-Progress-bar",
	match = {
		class = "^(thunar)$",
		title = "^(File Operation Progress|Confirm to replace files|Create New Folder)$",
	},
	float = true,
	size = "(monitor_w*0.2) (monitor_h*0.1)",
	move = "(monitor_w-window_w-10) 150",
})

hl.window_rule({
	name = "thunar",
	match = {
		class = "^(Thunar|thunar)$",
		title = "negative:^(File Operation Progress|Confirm to replace files|Create New Folder)$",
	},
	center = true,
	size = "(monitor_w*0.4) (monitor_h*0.7)",
})

hl.window_rule({
	match = { class = "^(org.test.pulsecontrol)$" },
	float = true,
	pin = true,
	size = "(monitor_w*0.3) (monitor_h*0.4)",
})

hl.window_rule({
	match = { class = "^(blueman-manager)$" },
	float = true,
	pin = true,
	size = "(monitor_w*0.15) (monitor_h*0.15)",
	move = "(cursor_x-(window_w*0.85)) (cursor_y-(window_h*0.07))",
})

hl.window_rule({
	match = { class = "^(org.gnome.Calculator)$" },
	size = "(monitor_w*0.1) (monitor_h*0.4)",
})

hl.window_rule({
	match = { class = "^(discord)$" },
	workspace = "3 silent",
	float = true,
	size = "(monitor_w*0.5) (monitor_h*0.8)",
})

hl.window_rule({
	match = { class = "kitty-floating" },
	float = true,
	size = "(monitor_w*0.3) (monitor_h*0.5)",
	center = true,
})

hl.window_rule({
	match = { title = "^(Picture-in-Picture)$" },
	keep_aspect_ratio = true,
})

hl.window_rule({
	match = { fullscreen = true },
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	match = { class = "Microsoft-edge", title = "\\(PWA\\)" },
	tile = true,
})

hl.window_rule({
	match = { class = "Microsoft-edge", title = "\\(Teams\\)" },
	tile = true,
})

hl.window_rule({
	match = {
		class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter|xdg-desktop-portal-gtk)$",
	},
	size = "(monitor_w*0.7) (monitor_h*0.7)",
})

hl.window_rule({
	match = { title = "^(Save As)$" },
	float = true,
	size = "(monitor_w*0.3) (monitor_h*0.6)",
})

hl.window_rule({
	match = { title = "^(Open.*)$" },
	float = true,
	size = "(monitor_w*0.3) (monitor_h*0.6)",
})

hl.window_rule({
	match = { title = "^(Friends List)$" },
	float = true,
	size = "(monitor_w*0.2) (monitor_h*0.5)",
})

hl.window_rule({
	match = { class = "^([Mm]pv)$" },
	no_blur = true,
	opacity = "1.0",
})

hl.window_rule({
	match = { class = "^(gamescope|steam_app_\\d+)$" },
	workspace = "8 silent",
	no_blur = true,
	opacity = "1.0",
	fullscreen = false,
	no_anim = true,
	no_initial_focus = true,
})

hl.window_rule({
	match = { content = "game" },
	workspace = "8 silent",
	no_blur = true,
	opacity = "1.0",
	fullscreen = false,
	no_anim = true,
	no_initial_focus = true,
})

-- XWayland tempfix: empty-class/empty-title float to cursor
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		initial_class = "^$",
		initial_title = "^$",
	},
	no_initial_focus = true,
	float = true,
	move = "cursor_x cursor_y",
})

hl.layer_rule({
	match = {
		namespace = "^(dms:(bar|tooltip|toast|dock-context-menu|tray-menu-window|control-center|notification-center-popout|dash|system-update|process-list-popout|battery|popout|app-launcher))$",
	},
	ignore_alpha = 0.0,
})
