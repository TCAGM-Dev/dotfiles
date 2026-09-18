---@type PluginSpec
return {
	src = {
		"https://github.com/hrsh7th/nvim-cmp",

		"https://github.com/hrsh7th/cmp-nvim-lsp",
		"https://github.com/hrsh7th/cmp-buffer",
	},
	config = function()
		local cmp = require("cmp")

		---@param callback fun(fallback: fun(): nil): nil
		---@param modes string[]
		---@param selected boolean Additional filter for whether a completion option is selected
		local function openedMapping(callback, modes, selected)
			return cmp.mapping(function(fallback)
				if cmp.visible() then
					if selected ~= nil then
						if (cmp.get_selected_entry() ~= nil) ~= selected then
							return fallback()
						end

						return callback(fallback)
					end
				else
					return fallback()
				end
			end, modes)
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},

			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},

			mapping = cmp.mapping.preset.insert({
				["<A-k>"] = cmp.mapping.scroll_docs(-4),
				["<A-j>"] = cmp.mapping.scroll_docs(4),
				["<Esc>"] = cmp.mapping.abort(),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if not cmp.visible() then
						cmp.complete()
					end
					if cmp.get_selected_entry() == nil then
						cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
					else
						fallback()
					end
				end, {"i", "s"}),
				["l"] = openedMapping(function(fallback)
					cmp.confirm({select = true})
				end, {"i", "s"}, true),
				["j"] = openedMapping(function(fallback)
					cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
				end, {"i", "s"}, true),
				["k"] = openedMapping(function(fallback)
					cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
				end, {"i", "s"}, true)
			}),

			sources = cmp.config.sources({
				{name = "nvim_lsp"},
			}, {
				{name = "buffer"},
			}),
		})
	end
}
