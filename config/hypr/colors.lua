-- Reads ~/.config/hypr/colors.conf written by flavours (hyprlang vars)
-- and exposes them as a lua table.

local M = {}

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content
end

local function resolve_path()
    local xdg = os.getenv("XDG_CONFIG_HOME")
    local home = os.getenv("HOME")
    local candidates = {}
    if xdg and #xdg > 0 then
        table.insert(candidates, xdg .. "/hypr/colors.conf")
    end
    if home and #home > 0 then
        table.insert(candidates, home .. "/.config/hypr/colors.conf")
    end
    for _, p in ipairs(candidates) do
        local f = io.open(p, "r")
        if f then f:close(); return p end
    end
    return nil
end

local path = resolve_path()
local content = path and read_file(path) or ""

for name, value in content:gmatch("%$(%w+)%s*=%s*([^\r\n]+)") do
    M[name] = value:gsub("%s+$", "")
end

-- Safe fallbacks if colors.conf hasn't been generated yet
local fallback = {
    base00 = "rgb(1d2021)", base01 = "rgb(3c3836)", base02 = "rgb(504945)",
    base03 = "rgb(665c54)", base04 = "rgb(bdae93)", base05 = "rgb(d5c4a1)",
    base06 = "rgb(ebdbb2)", base07 = "rgb(fbf1c7)", base08 = "rgb(fb4934)",
    base09 = "rgb(fe8019)", base0A = "rgb(fabd2f)", base0B = "rgb(b8bb26)",
    base0C = "rgb(8ec07c)", base0D = "rgb(83a598)", base0E = "rgb(d3869b)",
    base0F = "rgb(d65d0e)",
}
for k, v in pairs(fallback) do
    if not M[k] then M[k] = v end
end

return M
