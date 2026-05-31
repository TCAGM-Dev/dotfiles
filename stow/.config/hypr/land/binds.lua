local apps = require("land/apps")

-- See https://wiki.hypr.land/Configuring/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- General binds
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close("activewindow"), {repeating = true})
hl.bind(mainMod .. " + ALT + C", hl.dsp.window.kill("activewindow"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd(apps.powermenu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(apps.fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float("toggle", "activewindow"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(apps.colorpicker))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd(apps.terminal .. " " .. apps.top))
hl.bind("PRINT", hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh display"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(apps.browser))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle"}))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({mode = "maximized", action = "toggle"}))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(apps.menu))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({workspace = "previous"}))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.exec_cmd("playerctl -a pause; pidof hyprlock || hyprlock"))
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), {locked = true})
hl.bind(mainMod .. " + N", hl.dsp.focus({workspace = "empty"}))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({workspace = "empty"}))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(apps.terminal .. " qalc -i", {float = true, center = true, size = {500, 600}})) -- TODO: test
hl.bind(mainMod .. " + ALT + S", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("tray"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({workspace = "special:tray"})) -- TODO: test

-- OBS Global hotkeys
for _, hotkey in ipairs({
	mainMod .. " + F11",
	mainMod .. " + SHIFT + F11",
	mainMod .. " + F12",
}) do hl.bind(hotkey, hl.dsp.pass({window = "class:^(com\\.obsproject\\.Studio)$"})) end

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({direction = "l"}))
hl.bind(mainMod .. " + right", hl.dsp.focus({direction = "r"}))
hl.bind(mainMod .. " + up", hl.dsp.focus({direction = "u"}))
hl.bind(mainMod .. " + down", hl.dsp.focus({direction = "d"}))
hl.bind(mainMod .. " + H", hl.dsp.focus({direction = "l"}))
hl.bind(mainMod .. " + L", hl.dsp.focus({direction = "r"}))
hl.bind(mainMod .. " + K", hl.dsp.focus({direction = "u"}))
hl.bind(mainMod .. " + J", hl.dsp.focus({direction = "d"}))

-- Move windows with mainMod + Shift + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({direction = "l"}))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({direction = "r"}))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({direction = "u"}))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({direction = "d"}))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({direction = "l"}))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({direction = "r"}))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({direction = "u"}))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({direction = "d"}))

for i = 1, 10 do
	hl.bind(mainMod .. " + " .. tostring(i % 10), hl.dsp.focus({workspace = i}))
	hl.bind(mainMod .. " + SHIFT + " .. tostring(i % 10), hl.dsp.window.move({workspace = i}))
	hl.bind(mainMod .. " + SHIFT + ALT + " .. tostring(i % 10), hl.dsp.window.move({workspace = i, follow = false}))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({workspace = "+1"})) -- TODO: test
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({workspace = "-1"})) -- TODO: test

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), {mouse = true}) -- TODO: test
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), {mouse = true}) -- TODO: test

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {repeating = true, locked = true})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {repeating = true, locked = true})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {repeating = true, locked = true})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {repeating = true, locked = true})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), {repeating = true, locked = true})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), {repeating = true, locked = true})

-- Media controls, requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))