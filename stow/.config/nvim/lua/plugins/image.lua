---@type Spec
return {
	src = "https://github.com/3rd/image.nvim",
	config = function()
		require("image").setup({
			integrations = {
				markdown = {
					only_render_image_at_cursor = true, -- Compat with render-markdown.nvim
				},
			},
		})
	end
}