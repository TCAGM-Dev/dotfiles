local gameTrayWorkspace = "game"
local gameTrayKey = "W"
local mainMod = "SUPER"

local gameMatchers = {
	"Minecraft.*",
	"steam_app_.*",
	"org.vinegarhq.Sober",
}

hl.workspace_rule({
	workspace = "special:" .. gameTrayWorkspace,

	layout = "scrolling",
	layout_opts = {
		direction = "right",
		column_width = 1.0,
	},
})

hl.bind(mainMod .. " + " .. gameTrayKey, hl.dsp.workspace.toggle_special(gameTrayWorkspace))
hl.bind(mainMod .. " + SHIFT + " .. gameTrayKey, hl.dsp.window.move({workspace = "special:" .. gameTrayWorkspace}))

for _, matcher in ipairs(gameMatchers) do
	hl.window_rule({
		match = {
			class = "^(" .. matcher .. ")$",
			title = "negative:.*(Launcher|launcher).*",
		},

		workspace = "special:" .. gameTrayWorkspace,
	})
end

hl.window_rule({
	match = {workspace = "special:" .. gameTrayWorkspace},

	content = "game",
	scrolling_width = 1,
})