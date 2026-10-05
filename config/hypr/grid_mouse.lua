-- Mouse move/resize for the grid layout (Hyprland's own drag/resize don't drive
-- lua layouts). Both fall back to the native dispatchers outside the grid.
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

local function layout_msg(msg)
	hl.dispatch(hl.dsp.layout(msg))
end

-- one timer drives both gestures
local mode, id, last, edge, timer
local drag_win, drag_off -- move: the floated window and the cursor offset in it

local function float(w, enable)
	hl.dispatch(hl.dsp.window.float({ action = enable and "enable" or "disable", window = "address:" .. w.address }))
end

local function tick()
	local cur = hl.get_cursor_pos()
	if not (mode and cur) then return end
	if mode == "resize" then
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
	local was, w = mode, drag_win
	mode, drag_win = nil, nil
	if was ~= "move" then return end
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

hl.bind("SUPER + mouse:272", function()
	local pos = hl.get_cursor_pos()
	local w = in_grid() and pos and window_at(pos)
	if w then
		drag_win = w
		drag_off = { x = pos.x - coord(w.at, "x", 1), y = pos.y - coord(w.at, "y", 2) }
		float(w, true)
		layout_msg("detach " .. w.stable_id)
		start("move", w.stable_id)
	else
		hl.dispatch(hl.dsp.window.drag())
	end
end, { mouse = true })

hl.bind("SUPER + mouse:273", function()
	local pos = hl.get_cursor_pos()
	local w, px, py
	if in_grid() and pos then
		w, px, py = window_at(pos)
	end
	if w then
		last, edge = pos, { px < 50 and "l" or "r", py < 50 and "t" or "b" }
		start("resize", w.stable_id)
	else
		hl.dispatch(hl.dsp.window.resize())
	end
end, { mouse = true })

hl.bind("SUPER + mouse:272", stop, { release = true, ignore_mods = true, non_consuming = true })
hl.bind("SUPER + mouse:273", stop, { release = true, ignore_mods = true, non_consuming = true })
