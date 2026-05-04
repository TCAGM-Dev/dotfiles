import Quickshell.Services.UPower

BarModule {
	readonly property list<string> icons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
	readonly property list<string> iconsCharging: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
	function getIcon(set: list<string>, level: real): string {
		if (level <= 0) return set[0]
		if (level >= 1) return set[set.length - 1]

		return set[Math.floor(level * (set.length - 1))]
	}
	function getColor(level: real): string {
		if (level <= 0.1) return "#f90404"
		if (level <= 0.3) return "#f9ac04"
		return "white"
	}

	property bool showPower: false

	readonly property real percentage: UPower.displayDevice.percentage
	text: showPower ?
		`${UPower.displayDevice.changeRate}W 󱐋` :
		`${Math.round(percentage * 100)}% ${getIcon(UPower.displayDevice.state == UPowerDeviceState.Charging ? iconsCharging : icons, percentage)}`
	color: getColor(percentage)
	
	onClicked: showPower = !showPower
}
