-- https://wiki.hypr.land/Configuring/Variables/#render
hl.config({
	render = {
		direct_scanout = 1,
		--cm_fs_passthrough = 2, -- FIXME: unknown key?
		send_content_type = true,
		cm_auto_hdr = 1,
	},
	quirks = {
		prefer_hdr = 1, -- TODO: test
	},
})