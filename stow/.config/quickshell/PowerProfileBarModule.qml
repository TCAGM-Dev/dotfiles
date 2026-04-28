BarModule {
	property var profileData: {
		"power-saver": {name: "Ecological", icon: "", color: "#37ffc0", next: "balanced"},
		"balanced": {name: "Balanced", icon: "", color: "white", next: "performance"},
		"performance": {name: "Performance", icon: "", color: "#ffce2e", next: "power-saver"},
	}

	text: `󰓅 ${profileData[PowerProfile.activeProfile].icon}`
	color: profileData[PowerProfile.activeProfile].color
	font.family: "Symbols Nerd Font" // Non-monospace to make the spacing better
	gap: 5

	onClicked: () => PowerProfile.activeProfile = profileData[PowerProfile.activeProfile].next
}
