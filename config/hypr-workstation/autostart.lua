hl.on("hyprland.start", function()
	local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

	hl.exec_cmd("uwsm-app -- solaar -w hide")
	hl.exec_cmd("[workspace 1 silent] uwsm-app -- kitty.desktop")
	hl.exec_cmd("[workspace 1 silent] uwsm-app -- zen-browser.desktop")
	hl.exec_cmd(scriptsDir .. "/startEdgeStack.sh")
	hl.exec_cmd("[workspace 2 silent] uwsm-app -- slack.desktop")
	hl.exec_cmd("[workspace 4 silent] uwsm-app -- spotify.desktop")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
