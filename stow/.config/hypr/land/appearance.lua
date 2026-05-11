-- Refer to https://wiki.hypr.land/Configuring/Variables/

hl.config({
	-- https://wiki.hypr.land/Configuring/Variables/#general
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 1,

		-- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
		col = {
			active_border = "rgba(ffffffee)",
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = true,

		layout = "dwindle",
	},

	-- https://wiki.hypr.land/Configuring/Variables/#decoration
	decoration = {
		rounding = 6,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 0.8,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		-- https://wiki.hypr.land/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 3,
			passes = 1,

			vibrancy = 0.1696,
		},
	},

	animations = {enabled = true},
})

-- https://wiki.hypr.land/Configuring/Variables/#animations

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
--        NAME,                                         X0,   Y0,    X1,    Y1
hl.curve("easeOutQuint",   {type = "bezier", points = {{0.23, 1},    {0.32, 1}}})
hl.curve("easeInOutCubic", {type = "bezier", points = {{0.65, 0.05}, {0.36, 1}}})
hl.curve("linear",         {type = "bezier", points = {{0,    0},    {1,    1}}})
hl.curve("almostLinear",   {type = "bezier", points = {{0.5,  0.5},  {0.75, 1}}})
hl.curve("quick",          {type = "bezier", points = {{0.15, 0},    {0.1,  1}}})

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
--            NAME,                         ONOFF,          SPEED,         CURVE,                     [STYLE]
hl.animation({leaf = "global",              enabled = true, speed = 10,    bezier = "default"})
hl.animation({leaf = "border",              enabled = true, speed = 5.39,  bezier = "easeOutQuint"})
hl.animation({leaf = "windows",             enabled = true, speed = 4.79,  bezier = "easeOutQuint"})
hl.animation({leaf = "windowsIn",           enabled = true, speed = 4.1,   bezier = "easeOutQuint",   style = "popin 87%"})
hl.animation({leaf = "windowsOut",          enabled = true, speed = 1.49,  bezier = "linear",         style = "popin 87%"})
hl.animation({leaf = "fadeIn",              enabled = true, speed = 1.73,  bezier = "almostLinear"})
hl.animation({leaf = "fadeOut",             enabled = true, speed = 1.46,  bezier = "almostLinear"})
hl.animation({leaf = "fade",                enabled = true, speed = 3.03,  bezier = "quick"})
hl.animation({leaf = "layers",              enabled = true, speed = 3.81,  bezier = "easeOutQuint"})
hl.animation({leaf = "layersIn",            enabled = true, speed = 4,     bezier = "easeOutQuint",   style = "fade"})
hl.animation({leaf = "layersOut",           enabled = true, speed = 1.5,   bezier = "linear",         style = "fade"})
hl.animation({leaf = "fadeLayersIn",        enabled = true, speed = 1.79,  bezier = "almostLinear"})
hl.animation({leaf = "fadeLayersOut",       enabled = true, speed = 1.39,  bezier = "almostLinear"})
hl.animation({leaf = "workspaces",          enabled = true, speed = 1.94,  bezier = "almostLinear",   style = "fade"})
hl.animation({leaf = "workspacesIn",        enabled = true, speed = 1.21,  bezier = "almostLinear",   style = "slide"})
hl.animation({leaf = "workspacesOut",       enabled = true, speed = 1.21,  bezier = "almostLinear",   style = "slide"})
hl.animation({leaf = "specialWorkspaceIn",  enabled = true, speed = 1.14,  bezier = "linear",         style = "slidevert"})
hl.animation({leaf = "specialWorkspaceOut", enabled = true, speed = 1.14,  bezier = "linear",         style = "slidevert"})
hl.animation({leaf = "zoomFactor",          enabled = true, speed = 7,     bezier = "quick"})

-- Global font
hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name \"Adwaita Mono 11\"")

-- Themes
hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme \"FoolMoonNight\"")      -- GTK3
hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\"")     -- GTK4
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")                                                   -- Qt