-- N windows -> N equal-width columns side by side.
-- Sorted by stable_id (creation order) so saving this file or refocusing
-- between windows doesn't reshuffle columns.
hl.layout.register("columns", {
	recalculate = function(ctx)
		local n = #ctx.targets
		if n == 0 then
			return
		end

		local sorted = {}
		for _, target in ipairs(ctx.targets) do
			sorted[#sorted + 1] = target
		end
		table.sort(sorted, function(a, b)
			local aid = (a.window and a.window.stable_id) or a.index or 0
			local bid = (b.window and b.window.stable_id) or b.index or 0
			return aid < bid
		end)

		for i, target in ipairs(sorted) do
			target:place(ctx:column(i, n))
		end
	end,
})
