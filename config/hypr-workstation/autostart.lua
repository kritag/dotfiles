hl.on("hyprland.start", function()
	local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

	hl.exec_cmd("runapp -o -- solaar -w hide")
	hl.exec_cmd("[workspace 1 silent] runapp -o -- kitty")
	hl.exec_cmd("[workspace 1 silent] runapp -o -- zen-browser")
	hl.exec_cmd(scriptsDir .. "/startEdgeStack.sh")
	hl.exec_cmd("[workspace 2 silent] runapp -o -- slack")
	hl.exec_cmd("[workspace 4 silent] runapp -o -- spotify")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
