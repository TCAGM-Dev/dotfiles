import Quickshell.Services.UPower

BarModule {
	readonly property var profileData: (() => {
		const result = new Map()

		result.set(PowerProfile.PowerSaver, {name: "Ecological", icon: "", color: "#37ffc0", next: PowerProfile.Balanced})
		result.set(PowerProfile.Balanced, {name: "Balanced", icon: "", color: "white", next: PowerProfile.Performance})
		result.set(PowerProfile.Performance, {name: "Performance", icon: "", color: "#ffce2e", next: PowerProfile.PowerSaver})

		return result
	})()

	text: `󰓅 ${profileData.get(PowerProfiles.profile).icon}`
	color: profileData.get(PowerProfiles.profile).color
	font.family: "Symbols Nerd Font" // Non-monospace to make the spacing better
	gap: 5

	onClicked: () => PowerProfiles.profile = profileData.get(PowerProfiles.profile).next
}