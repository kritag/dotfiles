-- N-column-with-vertical-overflow layout.
--   1 window:  1 column full width
--   2 windows: 2 columns 50/50
--   3 windows: 3 columns 33/33/33
--   4+ windows: still 3 columns; the new window stacks under the FOCUSED column.
--
-- max_columns is configurable. Each column is its own vertical stack of windows.

local max_columns = 3

local state_file = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/hypr-grid-layout.lua"

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

local function save_state()
    local f = io.open(state_file, "w")
    if not f then return end
    f:write("return " .. serialize(state) .. "\n")
    f:close()
end

local function target_id(target)
    local w = target.window
    return w and tostring(w.stable_id) or tostring(target.index)
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
    state.workspaces[tostring(id)] = state.workspaces[tostring(id)] or { columns = {} }
    return state.workspaces[tostring(id)]
end

local function active_id(ctx)
    for _, target in ipairs(ctx.targets) do
        local w = target.window
        if w and w.active then return target_id(target) end
    end
end

-- Returns (col_idx, row_idx) or nil
local function find_window(ws, id)
    for col_i, col in ipairs(ws.columns) do
        for row_i, wid in ipairs(col) do
            if wid == id then return col_i, row_i end
        end
    end
end

-- Set of all window IDs currently tracked
local function tracked_set(ws)
    local set = {}
    for _, col in ipairs(ws.columns) do
        for _, id in ipairs(col) do set[id] = true end
    end
    return set
end

-- Returns map id -> target for current recalc batch
local function build_targets(ctx)
    local targets = {}
    for _, t in ipairs(ctx.targets) do
        targets[target_id(t)] = t
    end
    return targets
end

-- Place a column's windows vertically inside its box.
local function place_column(ctx, col_box, targets, ids)
    local n = #ids
    if n == 0 then return end

    local remaining = col_box
    for i = 1, n - 1 do
        local fraction = 1 / (n - i + 1)
        local row = ctx:split(remaining, "top", fraction)
        if targets[ids[i]] then targets[ids[i]]:place(row) end
        remaining = ctx:split(remaining, "bottom", 1 - fraction)
    end
    if targets[ids[n]] then targets[ids[n]]:place(remaining) end
end

-- Flatten ws.columns into a left-to-right, top-to-bottom id list.
local function flatten(ws)
    local out = {}
    for _, col in ipairs(ws.columns) do
        for _, id in ipairs(col) do out[#out + 1] = id end
    end
    return out
end

-- Detect external reorder (e.g. mouse drag → Hyprland's swapTargets reorders
-- the C++ target list). If ctx.targets order doesn't match our ws.columns
-- flattened order, reshape ws.columns using ctx.targets while preserving the
-- per-column count.
local function sync_external_order(ctx, ws)
    local ctx_ids = {}
    for _, t in ipairs(ctx.targets) do ctx_ids[#ctx_ids + 1] = target_id(t) end

    local flat = flatten(ws)
    if #ctx_ids ~= #flat then return false end
    local same = true
    for i = 1, #ctx_ids do
        if ctx_ids[i] ~= flat[i] then same = false; break end
    end
    if same then return false end

    local shape = {}
    for _, col in ipairs(ws.columns) do shape[#shape + 1] = #col end

    ws.columns = {}
    local idx = 1
    for col_i = 1, #shape do
        local col = {}
        for _ = 1, shape[col_i] do
            if ctx_ids[idx] then col[#col + 1] = ctx_ids[idx]; idx = idx + 1 end
        end
        if #col > 0 then ws.columns[#ws.columns + 1] = col end
    end
    save_state()
    return true
end

-- Ingest any new windows from ctx.targets into ws.columns.
local function sync_new(ctx, ws)
    local tracked = tracked_set(ws)
    local focused = active_id(ctx)
    local changed = false

    for _, t in ipairs(ctx.targets) do
        local id = target_id(t)
        if not tracked[id] then
            if #ws.columns < max_columns then
                table.insert(ws.columns, { id })
            else
                -- find focused window's column, append; fallback to last column
                local col_i = focused and select(1, find_window(ws, focused)) or #ws.columns
                table.insert(ws.columns[col_i], id)
            end
            changed = true
        end
    end

    if changed then save_state() end
end

-- Remove a window id from ws.columns; collapse empty columns.
local function remove_id(ws, id)
    local changed = false
    for col_i = #ws.columns, 1, -1 do
        local col = ws.columns[col_i]
        for row_i = #col, 1, -1 do
            if col[row_i] == id then
                table.remove(col, row_i)
                changed = true
            end
        end
        if #col == 0 then
            table.remove(ws.columns, col_i)
            changed = true
        end
    end
    return changed
end

hl.layout.register("grid", {
    recalculate = function(ctx)
        local ws = ws_state(ctx)
        if not ws then return end

        sync_new(ctx, ws)
        sync_external_order(ctx, ws)
        local targets = build_targets(ctx)

        local n_cols = #ws.columns
        if n_cols == 0 then return end

        for col_i = 1, n_cols do
            local col_box = ctx:column(col_i, n_cols)
            place_column(ctx, col_box, targets, ws.columns[col_i])
        end
    end,

    layout_msg = function(ctx, msg)
        local ws = ws_state(ctx)
        if not ws then return true end

        local focused = active_id(ctx)
        if not focused then return true end

        local col_i, row_i = find_window(ws, focused)
        if not col_i then return true end

        local command = msg:match("^(%S+)")

        if command == "move-left" then
            if col_i > 1 then
                table.remove(ws.columns[col_i], row_i)
                table.insert(ws.columns[col_i - 1], focused)
                if #ws.columns[col_i] == 0 then table.remove(ws.columns, col_i) end
                save_state()
            end
        elseif command == "move-right" then
            if col_i < #ws.columns then
                table.remove(ws.columns[col_i], row_i)
                table.insert(ws.columns[col_i + 1], focused)
                if #ws.columns[col_i] == 0 then table.remove(ws.columns, col_i) end
                save_state()
            elseif #ws.columns[col_i] > 1 and #ws.columns < max_columns then
                -- extract into a new rightmost column
                table.remove(ws.columns[col_i], row_i)
                table.insert(ws.columns, { focused })
                save_state()
            end
        elseif command == "move-up" then
            if row_i > 1 then
                local col = ws.columns[col_i]
                col[row_i], col[row_i - 1] = col[row_i - 1], col[row_i]
                save_state()
            end
        elseif command == "move-down" then
            local col = ws.columns[col_i]
            if row_i < #col then
                col[row_i], col[row_i + 1] = col[row_i + 1], col[row_i]
                save_state()
            end
        elseif command == "swap-col-left" then
            if col_i > 1 then
                ws.columns[col_i], ws.columns[col_i - 1] = ws.columns[col_i - 1], ws.columns[col_i]
                save_state()
            end
        elseif command == "swap-col-right" then
            if col_i < #ws.columns then
                ws.columns[col_i], ws.columns[col_i + 1] = ws.columns[col_i + 1], ws.columns[col_i]
                save_state()
            end
        end

        return true
    end,
})

hl.on("window.close", function(window)
    local id = window and tostring(window.stable_id)
    if not id then return end
    local any = false
    for _, ws in pairs(state.workspaces) do
        if remove_id(ws, id) then any = true end
    end
    if any then save_state() end
end)
