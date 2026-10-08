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
    local ws = state.workspaces[tostring(id)] or { columns = {} }
    state.workspaces[tostring(id)] = ws
    ws.weights = ws.weights or {}
    return ws
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

local function weight(ws, id)
    return ws.weights[id] or 1
end

-- Split `box` into len(weights) pieces sized proportionally, along `first`/`rest` sides.
local function split_weighted(ctx, box, weights, first, rest)
    local out = {}
    local remaining = box
    local total = 0
    for _, w in ipairs(weights) do total = total + w end
    for i = 1, #weights - 1 do
        local fraction = weights[i] / total
        out[i] = ctx:split(remaining, first, fraction)
        remaining = ctx:split(remaining, rest, 1 - fraction)
        total = total - weights[i]
    end
    out[#weights] = remaining
    return out
end

-- Weighted splits produce fractional pixels; clients end up with a surface that
-- doesn't match the window box. Snap to whole pixels from the edges so that
-- neighbouring cells still meet exactly.
local function snap(b)
    local x0, y0 = math.floor(b.x + 0.5), math.floor(b.y + 0.5)
    local x1, y1 = math.floor(b.x + b.w + 0.5), math.floor(b.y + b.h + 0.5)
    return { x = x0, y = y0, w = x1 - x0, h = y1 - y0 }
end

-- Place a column's windows inside its box: stacked vertically, or side by side if col.h.
local function place_column(ctx, ws, col_box, targets, ids, horizontal)
    if #ids == 0 then return end
    local weights = {}
    for i, id in ipairs(ids) do weights[i] = weight(ws, id) end
    local first, rest = "top", "bottom"
    if horizontal then first, rest = "left", "right" end
    for i, cell in ipairs(split_weighted(ctx, col_box, weights, first, rest)) do
        if targets[ids[i]] then targets[ids[i]]:place(snap(cell)) end
    end
end

-- Detect external reorder (e.g. mouse drag -> Hyprland swaps two entries in
-- the C++ target list). ws.columns is our own source of truth and is allowed to
-- differ from ctx.targets order (move-left etc. never touch the C++ list), so
-- compare against the previously seen ctx order, not against ws.columns.
local last_order = {}

local function sync_external_order(ctx, ws, ws_key)
    local cur = {}
    for _, t in ipairs(ctx.targets) do cur[#cur + 1] = target_id(t) end

    local prev = last_order[ws_key]
    last_order[ws_key] = cur
    if not prev or #prev ~= #cur then return false end

    local diff = {}
    for i = 1, #cur do
        if prev[i] ~= cur[i] then diff[#diff + 1] = i end
    end
    if #diff ~= 2 then return false end

    -- two entries traded places: trade them in ws.columns too
    local a, b = prev[diff[1]], prev[diff[2]]
    local ca, ra = find_window(ws, a)
    local cb, rb = find_window(ws, b)
    if not (ca and cb) then return false end
    ws.columns[ca][ra], ws.columns[cb][rb] = b, a
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
        local floating = t.window and t.window.floating
        if not tracked[id] and not floating then
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

        sync_external_order(ctx, ws, tostring(ws_id_from_ctx(ctx)))
        -- Windows that floated, left this workspace, or are gone give up their
        -- slot. Judge by the window itself, not by ctx.targets: on a config
        -- reload Hyprland re-adds targets one at a time, and a partial list
        -- must not wipe the saved columns.
        local wsid = ws_id_from_ctx(ctx)
        local alive, tiled_here = {}, 0
        for _, w in ipairs(hl.get_windows()) do
            local here = w.mapped and w.workspace and w.workspace.id == wsid
            if here and not w.floating then
                alive[tostring(w.stable_id)] = true
                tiled_here = tiled_here + 1
            end
        end
        local purged = false
        for id in pairs(tracked_set(ws)) do
            if not alive[id] and remove_id(ws, id) then purged = true end
        end
        if purged then save_state() end

        -- Mid-rebuild (fewer targets than tiled windows): hold off placing, or
        -- every client gets a burst of transient sizes and can end up stale.
        if #ctx.targets < tiled_here then return end

        sync_new(ctx, ws)
        local targets = build_targets(ctx)

        local n_cols = #ws.columns
        if n_cols == 0 then return end

        local col_weights = {}
        for i, col in ipairs(ws.columns) do col_weights[i] = col.w or 1 end
        local boxes = split_weighted(ctx, ctx:column(1, 1), col_weights, "left", "right")
        for col_i, box in ipairs(boxes) do
            local col = ws.columns[col_i]
            place_column(ctx, ws, box, targets, col, col.h)
        end
    end,

    layout_msg = function(ctx, msg)
        local ws = ws_state(ctx)
        if not ws then return true end

        local mouse_cmd = msg:match("^(%S+)")

        if mouse_cmd == "detach" then
            -- "detach <id>": window is being dragged (floated); free its slot
            if remove_id(ws, msg:match("^%S+%s+(%d+)")) then save_state() end
            return true
        elseif mouse_cmd == "drop" then
            -- "drop <id> <target> <px> <py>": dragged window released over
            -- `target`; px/py is the cursor position inside it, 0-100. The
            -- window joins the target's column on the side the cursor is on.
            local id, target, px, py = msg:match("^%S+%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
            remove_id(ws, id)
            local dc, dr = find_window(ws, target)
            if not dc then return true end
            local dest = ws.columns[dc]
            local after = (dest.h and tonumber(px) or tonumber(py)) > 50
            table.insert(dest, dr + (after and 1 or 0), id)
            ws.weights[id] = nil
            save_state()
            return true
        elseif mouse_cmd == "mresize" then
            -- "mresize <id> <dx> <dy> <l|r> <t|b>": pixel deltas from a mouse
            -- drag, grabbed on the given side of the window. Only the boundary
            -- on that side moves (the neighbour gives or takes the space).
            local id, dx, dy, ex, ey = msg:match("^%S+%s+(%d+)%s+(-?%d+)%s+(-?%d+)%s+(%a)%s+(%a)")
            local ci, ri = find_window(ws, id)
            if not ci then return true end
            dx, dy = tonumber(dx), tonumber(dy)
            local area = ctx.area
            local c = ws.columns[ci]

            -- move the boundary between item i and its neighbour by dpx pixels
            local function shift(n, get, set, i, side, dpx, extent)
                if n < 2 or extent <= 0 then return end
                if not (i + side >= 1 and i + side <= n) then side = -side end
                local j = i + side
                local total = 0
                for k = 1, n do total = total + get(k) end
                local dw = side * dpx / extent * total
                local wi, wj = get(i), get(j)
                dw = math.max(0.2 - wi, math.min(wj - 0.2, dw))
                set(i, wi + dw)
                set(j, wj - dw)
            end
            local function col_get(k) return ws.columns[k].w or 1 end
            local function col_set(k, v) ws.columns[k].w = v end
            local function win_get(k) return weight(ws, c[k]) end
            local function win_set(k, v) ws.weights[c[k]] = v end

            local xside = ex == "l" and -1 or 1
            local yside = ey == "t" and -1 or 1
            if c.h then
                local cols_total = 0
                for k = 1, #ws.columns do cols_total = cols_total + col_get(k) end
                shift(#c, win_get, win_set, ri, xside, dx, area.w * col_get(ci) / cols_total)
            else
                shift(#ws.columns, col_get, col_set, ci, xside, dx, area.w)
                shift(#c, win_get, win_set, ri, yside, dy, area.h)
            end
            save_state()
            return true
        end

        local focused = active_id(ctx)
        if not focused then return true end

        local col_i, row_i = find_window(ws, focused)
        if not col_i then return true end

        local command = msg:match("^(%S+)")
        local col = ws.columns[col_i]

        -- move focused window to the neighbouring column (keeps its row position)
        local function cross(dir)
            local dest_i = col_i + dir
            local dest = ws.columns[dest_i]
            table.remove(col, row_i)
            if dest then
                table.insert(dest, math.min(row_i, #dest + 1), focused)
            elseif #ws.columns < max_columns then
                -- extract into a new outermost column
                dest_i = dir < 0 and 1 or #ws.columns + 1
                table.insert(ws.columns, dest_i, { focused })
            else
                table.insert(col, row_i, focused)
                return
            end
            if #col == 0 then table.remove(ws.columns, col_i) end
            save_state()
        end

        local function swap_in_column(dir)
            local j = row_i + dir
            if j < 1 or j > #col then return false end
            col[row_i], col[j] = col[j], col[row_i]
            save_state()
            return true
        end

        if command == "togglesplit" then
            -- flip only the focused column: stacked <-> side by side
            col.h = (not col.h) or nil
            save_state()
        elseif command == "move-left" or command == "move-right" then
            local dir = command == "move-left" and -1 or 1
            if col.h and swap_in_column(dir) then return true end
            -- at the edge of a lone window there is nowhere new to go
            local dest = ws.columns[col_i + dir]
            if dest or #col > 1 then cross(dir) end
        elseif command == "move-up" or command == "move-down" then
            if not col.h then swap_in_column(command == "move-up" and -1 or 1) end
        elseif command == "swap-col-left" and col_i > 1 then
            ws.columns[col_i], ws.columns[col_i - 1] = ws.columns[col_i - 1], ws.columns[col_i]
            save_state()
        elseif command == "swap-col-right" and col_i < #ws.columns then
            ws.columns[col_i], ws.columns[col_i + 1] = ws.columns[col_i + 1], ws.columns[col_i]
            save_state()
        elseif command == "resize" then
            -- "resize <dx> <dy>": grow (+) or shrink (-) the focused window along that axis
            local dx, dy = msg:match("^%S+%s+(-?%d+)%s+(-?%d+)")
            dx, dy = tonumber(dx) or 0, tonumber(dy) or 0
            local step = 0.1
            local function bump(old, d) return math.max(0.2, old + step * d) end
            if dx ~= 0 then
                if col.h then
                    ws.weights[focused] = bump(weight(ws, focused), dx)
                else
                    col.w = bump(col.w or 1, dx)
                end
            end
            if dy ~= 0 and not col.h then
                ws.weights[focused] = bump(weight(ws, focused), dy)
            end
            save_state()
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
