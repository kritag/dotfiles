hl.on("hyprland.start", function()
	local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

	hl.exec_cmd("[workspace 1 silent] runapp -o -- kitty")
	hl.exec_cmd("[workspace 1 silent] runapp -o -- zen-browser")
	hl.exec_cmd(scriptsDir .. "/startEdgeStack.sh")
	-- slack registers its tray icon once at startup, so wait for dms's StatusNotifierWatcher
	hl.exec_cmd("[workspace 2 silent] sh -c 'until busctl --user status org.kde.StatusNotifierWatcher >/dev/null 2>&1; do sleep 0.5; done; exec runapp -o -- slack'")
	hl.exec_cmd("[workspace 4 silent] runapp -o -- spotify")
	hl.exec_cmd("hyprctl dispatch workspace 1")
end)
