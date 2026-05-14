-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

hl.window_rule({
    -- Ignore maximize requests from all apps.
    name = "suppress-maximize-events",

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

    no_focus = true,
})

hl.window_rule({
    name = "blueman-dock",

	match = {
		class = "blueman-manager",
		tag = "waybar",
	},

    float = true,
    pin = true,
    size = {528, 603},
    move = {"(monitor_w-528-10)", "(monitor_h-603-32-10)"},
    animation = "slide bottom",
})

hl.window_rule({
    name = "blueman-dock",

	match = {
		class = "blueman-manager",
		tag = "shell",
	},

    float = true,
    pin = true,
    size = {528, 603},
    move = {"(monitor_w-528-10)", "(monitor_h-603-32-10)"},
    animation = "slide bottom",
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",

    match = {class = "hyprland-run"},

    move = {20, "(monitor_h-120)"},
    float = true,
})

hl.window_rule({
    name = "no-fullscreen-spaceengineers",

    match = {class = "spaceengineers.exe"},

    fullscreen_state = 1,
})

-- Enable tearing
hl.window_rule({
    name = "tearing",
    match = {fullscreen = true},

    immediate = true,
})

for _, namespace in ipairs({"rofi", "quickshell_launcher"}) do
	hl.layer_rule({match = {namespace = namespace}, no_anim = true, blur = true})
end

-- Tray special workspace
-- workspace = special:tray, layout:scrolling, layoutopt:direction:down
hl.workspace_rule({workspace = "special:tray", layout = "scrolling", layout_opts = {direction = "down"}}) -- TODO: test

hl.window_rule({
    name = "float_thunar_rename_popup",
	match = {
		initial_class = "(Thunar|thunar)",
		initial_title = "^Rename \".*\"$",
	},

    float = true,
    stay_focused = true,
})

hl.window_rule({
    name = "mark_maximized_windows",
    match = {fullscreen_state_client = 1},

    border_color = "rgb(ffff77)",
})

hl.window_rule({
    name = "center_filechooser",
    match = {initial_class = "Xdg-desktop-portal-gtk"},

    float = true,
    center = true,
    size = {"(monitor_w/2)", "(monitor_h/2)"},
})