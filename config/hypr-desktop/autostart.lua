-- Desktop autostart. Symlinked to ~/.config/hypr/autostart.lua by dotbot.
-- Ported from env-desktop.conf.

hl.on("hyprland.start", function()
    local scriptsDir = (os.getenv("HOME") or "") .. "/.config/hypr/scripts"

    hl.exec_cmd("runapp -o -- solaar -w hide")
    hl.exec_cmd("[workspace 1 silent] runapp -o -- kitty")
    hl.exec_cmd("[workspace 1 silent] runapp -o -- zen-browser")
    hl.exec_cmd("[workspace 2 silent] runapp -o -- steam")
    hl.exec_cmd("[workspace 3 silent] runapp -o -- discord")
    hl.exec_cmd("[workspace 4 silent] runapp -o -- spotify-launcher")
    hl.exec_cmd("hyprctl dispatch workspace 1")
end)
