import Quickshell.Hyprland
import Quickshell.Bluetooth
import QtQuick.Layouts

BarModule {
	readonly property int deviceCount: Bluetooth.devices.values.filter(device => device.connected).length
	text: `${deviceCount == 0 ? "" : deviceCount}`

	onClicked: Hyprland.dispatch("exec [tag +shell] blueman-manager")
}