local concatArray = require("util").concatArray

return {
	src = "https://github.com/windwp/nvim-autopairs",
	config = function()
		local Rule = require("nvim-autopairs.rule")
		local nap = require("nvim-autopairs")

		nap.setup({})

		local jsLang = {"javascript", "typescript", "javascriptreact", "typescriptreact", "qmljs"}
		local luaLang = {"lua", "luau"}
		local xmlLang = {"xml", "html", "svg"}
		local cssLang = {"css", "scss", "less", "stylus"}

		nap.add_rules({
			Rule("(", ")"),
			Rule("{", "}"),
			Rule("[", "]"),

			Rule("\"", "\""),
			Rule("'", "'"),
			Rule("`", "`", jsLang),

			Rule("/*", "*/", concatArray(jsLang, cssLang)),

			Rule("%sthen$", "end", luaLang, "if_statement"):use_regex(true),
			Rule("%sdo$", "end", luaLang, {"while_loop", "for_loop"}):use_regex(true),
			Rule("function%s*%a*%s*%(.*%)$", "end", luaLang, {"function_declaration", "local_function", "function"}):use_regex(true),

			Rule("<%s*(%w+)%s*>$", "", xmlLang):use_regex(true)
				:replace_endpair(function(opts)
					return "</" .. string.match(opts.prev_char, opts.rule.start_pair) .. ">"
				end),
			Rule("<!--", "-->", xmlLang),
		})
	end
}