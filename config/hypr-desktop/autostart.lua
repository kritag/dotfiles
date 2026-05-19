-- Desktop autostart. Symlinked to ~/.config/hypr/autostart.lua by dotbot.
-- Ported from env-desktop.conf.

hl.on("hyprland.start", function()
    local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

    hl.exec_cmd("uwsm-app -- " .. scriptsDir .. "/floatBitwarden.sh")
    hl.exec_cmd("uwsm-app -- solaar -w hide")
    hl.exec_cmd("[workspace 1 silent] uwsm-app -- kitty.desktop")
    hl.exec_cmd("[workspace 1 silent] uwsm-app -- zen.desktop")
    hl.exec_cmd("[workspace 2 silent] uwsm-app -- steam.desktop")
    hl.exec_cmd("[workspace 3 silent] uwsm-app -- discord.desktop")
    hl.exec_cmd("[workspace 4 silent] uwsm-app -- spotify-launcher.desktop")
    hl.exec_cmd("hyprctl dispatch workspace 1")
end)
