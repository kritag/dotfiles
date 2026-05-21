-- i3/hy3-style manual layout. Each window splits the focused one in a direction
-- you choose; the tree is preserved across recalcs.
-- Layout messages (via hl.dsp.layout("...")):
--   splith / h          - next window will split horizontally (side by side)
--   splitv / v          - next window will split vertically (stacked)
--   splittoggle / toggle / togglesplit - flip current split direction
--   promote             - move active window to position 1
--   swapnext / swapprev - swap active window with next/prev in order
--   rotate              - flip every split direction in the tree

-- State must persist across `hyprctl reload` and lua-config :w auto-reloads.
-- Hyprland calls reinitLuaState() on every reload, destroying the lua state
-- and all globals — so we serialize to a file and reload on init.

local state_file = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/hypr-manual-layout.lua"

local function load_state()
    local f = loadfile(state_file)
    if f then
        local ok, data = pcall(f)
        if ok and type(data) == "table" then return data end
    end
    return nil
end

local function serialize(t, indent)
    indent = indent or ""
    local lines = { "{" }
    local next_indent = indent .. "  "
    for k, v in pairs(t) do
        local key
        if type(k) == "number" then
            key = "[" .. k .. "]"
        else
            key = "[" .. string.format("%q", tostring(k)) .. "]"
        end
        if type(v) == "table" then
            lines[#lines + 1] = next_indent .. key .. " = " .. serialize(v, next_indent) .. ","
        elseif type(v) == "string" then
            lines[#lines + 1] = next_indent .. key .. " = " .. string.format("%q", v) .. ","
        elseif type(v) == "number" or type(v) == "boolean" then
            lines[#lines + 1] = next_indent .. key .. " = " .. tostring(v) .. ","
        end
    end
    lines[#lines + 1] = indent .. "}"
    return table.concat(lines, "\n")
end

local state = load_state() or {}
state.workspaces = state.workspaces or {}
state.default_split = state.default_split or "h"

local function save_state()
    local f = io.open(state_file, "w")
    if not f then return end
    f:write("return " .. serialize(state) .. "\n")
    f:close()
end

local function target_id(target)
    local window = target.window
    return window and tostring(window.stable_id) or tostring(target.index)
end

local function ws_id_from_ctx(ctx)
    for _, target in ipairs(ctx.targets) do
        local w = target.window
        if w and w.workspace then return w.workspace.id end
    end
end

local function ws_state(ctx)
    local id = ws_id_from_ctx(ctx)
    if not id then return nil end
    state.workspaces[tostring(id)] = state.workspaces[tostring(id)] or { order = {}, split = {} }
    return state.workspaces[tostring(id)]
end

local function active_id(ctx, ws)
    for _, target in ipairs(ctx.targets) do
        local window = target.window
        if window and window.active then return target_id(target) end
    end
    return ws.order[#ws.order]
end

local function index_of(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
end

local function sync_order(ctx, ws)
    -- Don't remove windows just because they aren't in this batch — Hyprland
    -- can fire recalc with a partial target set during reload. Removals are
    -- handled by the window.close event subscription below.
    local targets = {}
    for _, target in ipairs(ctx.targets) do
        targets[target_id(target)] = target
    end

    local changed = false
    local focused = active_id(ctx, ws)
    for _, target in ipairs(ctx.targets) do
        local id = target_id(target)
        if not index_of(ws.order, id) then
            local after = focused and index_of(ws.order, focused)
            table.insert(ws.order, after and (after + 1) or (#ws.order + 1), id)
            changed = true
        end
    end

    if changed then save_state() end
    return targets
end

-- Filter stale ids (in ws.order but not in current targets) before chaining,
-- so a missing window doesn't break the placement of later ones.
local function live_ids(ws, targets)
    local out = {}
    for _, id in ipairs(ws.order) do
        if targets[id] then out[#out + 1] = id end
    end
    return out
end

local function place_chain(ctx, ws, targets, ids, area, i)
    if i > #ids then return end

    local target = targets[ids[i]]
    if i == #ids then
        target:place(area)
        return
    end

    local split = ws.split[ids[i]] or state.default_split
    if split == "v" then
        target:place(ctx:split(area, "top", 0.5))
        place_chain(ctx, ws, targets, ids, ctx:split(area, "bottom", 0.5), i + 1)
    else
        target:place(ctx:split(area, "left", 0.5))
        place_chain(ctx, ws, targets, ids, ctx:split(area, "right", 0.5), i + 1)
    end
end

local function move_active(ctx, ws, delta)
    local id = active_id(ctx, ws)
    local i = id and index_of(ws.order, id)
    local j = i and (i + delta)
    if not i or j < 1 or j > #ws.order then return end
    ws.order[i], ws.order[j] = ws.order[j], ws.order[i]
    save_state()
end

hl.layout.register("manual", {
    recalculate = function(ctx)
        local ws = ws_state(ctx)
        if not ws then return end

        local f = io.open("/tmp/manual-debug.log", "a")
        if f then
            local splits = {}
            for k, v in pairs(ws.split) do splits[#splits+1] = k .. "=" .. v end
            local ids = {}
            for _, t in ipairs(ctx.targets) do
                ids[#ids+1] = t.window and tostring(t.window.stable_id) or "?"
            end
            f:write(string.format("RECALC ws=%s targets=[%s] order=[%s] split={%s}\n",
                tostring(ws_id_from_ctx(ctx)),
                table.concat(ids, ","),
                table.concat(ws.order, ","),
                table.concat(splits, ",")))
            f:close()
        end

        local targets = sync_order(ctx, ws)
        place_chain(ctx, ws, targets, live_ids(ws, targets), ctx.area, 1)
    end,

    layout_msg = function(ctx, msg)
        local ws = ws_state(ctx)
        if not ws then return true end

        local id = active_id(ctx, ws)
        local command = msg:match("^(%S+)")

        if command == "splith" or command == "h" then
            if id then ws.split[id] = "h"; save_state() end
        elseif command == "splitv" or command == "v" then
            if id then ws.split[id] = "v"; save_state() end
        elseif command == "splittoggle" or command == "toggle" or command == "togglesplit" then
            if id then
                ws.split[id] = ws.split[id] == "v" and "h" or "v"
                save_state()
            end
        elseif command == "promote" then
            local i = id and index_of(ws.order, id)
            if i then
                table.remove(ws.order, i)
                table.insert(ws.order, 1, id)
                save_state()
            end
        elseif command == "swapnext" or command == "move-down" or command == "move-right" then
            move_active(ctx, ws, 1)
        elseif command == "swapprev" or command == "move-up" or command == "move-left" then
            move_active(ctx, ws, -1)
        elseif command == "rotate" then
            for k, v in pairs(ws.split) do
                ws.split[k] = v == "v" and "h" or "v"
            end
            state.default_split = state.default_split == "v" and "h" or "v"
            save_state()
        else
            return "manual: expected splith, splitv, splittoggle, promote, swapnext, swapprev, or rotate"
        end

        return true
    end,
})

-- Remove tracking for actually-closed windows. Without this, ws.order grows
-- unbounded (harmless but messy). sync_order no longer removes during recalc.
hl.on("window.close", function(window)
    local id = window and tostring(window.stable_id)
    if not id then return end
    local changed = false
    for _, ws in pairs(state.workspaces) do
        local i = index_of(ws.order, id)
        if i then table.remove(ws.order, i); changed = true end
        if ws.split[id] then ws.split[id] = nil; changed = true end
    end
    if changed then save_state() end
end)
