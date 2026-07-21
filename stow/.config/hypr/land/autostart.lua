hl.on("hyprland.start", function()
	hl.exec_cmd("hypridle")
	hl.exec_cmd("~/.bin/battery_notifier_daemon.sh")
	hl.exec_cmd("quickshell")

	hl.exec_cmd("discord --start-minimized")
end)