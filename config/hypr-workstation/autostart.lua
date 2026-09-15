hl.on("hyprland.start", function()
	local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

	hl.exec_cmd("uwsm-app -- " .. scriptsDir .. "/floatBitwarden.sh")
	hl.exec_cmd("uwsm-app -- solaar -w hide")
	hl.exec_cmd("[workspace 1 silent] uwsm-app -- kitty.desktop")
	hl.exec_cmd("[workspace 1 silent] uwsm-app -- zen-browser.desktop")
	-- Serialized: the tabbed Edge must own the Chromium singleton, or external
	-- URLs (oc login --web, Slack) open new windows instead of tabs.
	hl.exec_cmd("sleep 5; " .. scriptsDir .. "/startEdgeStack.sh")
	hl.exec_cmd("sleep 3; uwsm-app -- slack.desktop")
	hl.exec_cmd("[workspace 4 silent] uwsm-app -- spotify.desktop")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
