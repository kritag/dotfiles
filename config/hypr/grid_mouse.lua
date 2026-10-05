-- Mouse move/resize for the grid layout (Hyprland's own drag/resize don't drive
-- lua layouts). In the grid these binds replace the native ones, floating
-- windows included; in other layouts the native binds are active instead
-- (scripts/layout.sh calls grid_mouse_sync() on every layout change).
--   SUPER + left drag:  window floats and follows the cursor; on release it
--                       joins the column of the window it was dropped on
--   SUPER + right drag: resize; grabbing the left/right (top/bottom) half of a
--                       window moves the boundary on that side
local function in_grid()
	local ws = hl.get_active_workspace()
	return ws and ws.tiled_layout == "lua:grid"
end

local function coord(v, k, i)
	return v[k] or v[i]
end

local function window_at(pos, skip)
	local ws = hl.get_active_workspace()
	for _, w in ipairs(hl.get_windows()) do
		if w.mapped and not w.floating and w.workspace and w.workspace.id == ws.id and w.stable_id ~= skip then
			local x, y = coord(w.at, "x", 1), coord(w.at, "y", 2)
			local width, height = coord(w.size, "x", 1), coord(w.size, "y", 2)
			if pos.x >= x and pos.x < x + width and pos.y >= y and pos.y < y + height then
				return w, (pos.x - x) / width * 100, (pos.y - y) / height * 100
			end
		end
	end
end

local function floating_at(pos)
	local ws = hl.get_active_workspace()
	for _, w in ipairs(hl.get_windows()) do
		if w.mapped and w.floating and w.workspace and w.workspace.id == ws.id then
			local x, y = coord(w.at, "x", 1), coord(w.at, "y", 2)
			local width, height = coord(w.size, "x", 1), coord(w.size, "y", 2)
			if pos.x >= x and pos.x < x + width and pos.y >= y and pos.y < y + height then
				return w
			end
		end
	end
end

local function layout_msg(msg)
	hl.dispatch(hl.dsp.layout(msg))
end

-- one timer drives both gestures
local mode, id, last, edge, timer
local drag_win, drag_off, drag_tiled -- move: the dragged window, cursor offset in it, was it tiled

local function float(w, enable)
	hl.dispatch(hl.dsp.window.float({ action = enable and "enable" or "disable", window = "address:" .. w.address }))
end

local function tick()
	local cur = hl.get_cursor_pos()
	if not (mode and cur) then return end
	if mode == "fresize" then
		local dx, dy = math.floor(cur.x - last.x), math.floor(cur.y - last.y)
		if dx ~= 0 or dy ~= 0 then
			last = { x = last.x + dx, y = last.y + dy }
			hl.dispatch(hl.dsp.window.resize({ x = dx, y = dy, relative = true, window = "address:" .. drag_win.address }))
		end
	elseif mode == "resize" then
		local dx, dy = math.floor(cur.x - last.x), math.floor(cur.y - last.y)
		if dx ~= 0 or dy ~= 0 then
			last = { x = last.x + dx, y = last.y + dy }
			layout_msg(("mresize %d %d %d %s %s"):format(id, dx, dy, edge[1], edge[2]))
		end
	else
		hl.dispatch(hl.dsp.window.move({
			x = math.floor(cur.x - drag_off.x),
			y = math.floor(cur.y - drag_off.y),
			window = "address:" .. drag_win.address,
		}))
	end
end

local function start(m, win_id)
	mode, id = m, win_id
	timer = timer or hl.timer(tick, { timeout = 16, type = "repeat" })
	timer:set_enabled(true)
end

local function stop()
	if timer then timer:set_enabled(false) end
	local was, w, tiled = mode, drag_win, drag_tiled
	mode, drag_win = nil, nil
	if was ~= "move" or not tiled then return end
	-- drop: re-tile the window, then slot it next to whatever it was released on
	local cur = hl.get_cursor_pos()
	local target, px, py
	if cur then
		target, px, py = window_at(cur, w.stable_id)
	end
	float(w, false)
	if target then
		layout_msg(("drop %d %d %d %d"):format(w.stable_id, target.stable_id, math.floor(px), math.floor(py)))
	end
end

local grid_binds = {}
grid_binds[1] = hl.bind("SUPER + mouse:272", function()
	local pos = hl.get_cursor_pos()
	if not pos then return end
	local f = floating_at(pos)
	local w = f or window_at(pos)
	if not w then return end
	drag_win, drag_tiled = w, not f
	drag_off = { x = pos.x - coord(w.at, "x", 1), y = pos.y - coord(w.at, "y", 2) }
	if not f then
		float(w, true)
		layout_msg("detach " .. w.stable_id)
	end
	start("move", w.stable_id)
end, { mouse = true })

grid_binds[2] = hl.bind("SUPER + mouse:273", function()
	local pos = hl.get_cursor_pos()
	if not pos then return end
	local f = floating_at(pos)
	if f then
		drag_win, last = f, pos
		start("fresize", f.stable_id)
		return
	end
	local w, px, py = window_at(pos)
	if w then
		last, edge = pos, { px < 50 and "l" or "r", py < 50 and "t" or "b" }
		start("resize", w.stable_id)
	end
end, { mouse = true })

hl.bind("SUPER + mouse:272", stop, { release = true, ignore_mods = true, non_consuming = true })
hl.bind("SUPER + mouse:273", stop, { release = true, ignore_mods = true, non_consuming = true })

-- native drag/resize for every other layout
local native_binds = {
	hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }),
	hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }),
}

function grid_mouse_sync()
	local grid = hl.get_config("general.layout") == "lua:grid"
	for _, b in ipairs(grid_binds) do b:set_enabled(grid) end
	for _, b in ipairs(native_binds) do b:set_enabled(not grid) end
end
grid_mouse_sync()
