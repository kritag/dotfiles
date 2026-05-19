-- Ported from monitors.conf. v0.55.2 unifies monitor/monitorv2 into hl.monitor.
-- desc: matching is supported via the "desc:" prefix on output.

hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@120",
	position = "0x0",
	scale = 1.5,
	cm = "srgb",
})

hl.monitor({
	output = "desc:Lenovo Group Limited P34WD-40 V30FTZBN",
	mode = "3440x1440@119.99",
	position = "1920x0",
	scale = 1,
	vrr = 2,
	cm = "srgb",
	bitdepth = 10,
})

local samsung_c34h89x = {
	"HTRM100199",
	"HTOJ500164",
	"HTRJC00007",
	"HTJKC00538",
	"HTOK700175",
	"HTOJ701358s",
	"HTOJ800480",
	"H1AK500000",
}
for _, serial in ipairs(samsung_c34h89x) do
	hl.monitor({
		output = "desc:Samsung Electric Company C34H89x " .. serial,
		mode = "3440x1440@99.98",
		position = "1920x0",
		scale = 1,
		cm = "srgb",
	})
end
