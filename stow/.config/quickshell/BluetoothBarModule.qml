import Quickshell
import Quickshell.Bluetooth
import QtQuick.Layouts

BarModule {
	readonly property int deviceCount: Bluetooth.devices.values.filter(device => device.connected).length
	text: `${deviceCount == 0 ? "" : deviceCount}`

	onClicked: Quickshell.execDetached(["hyprctl", "eval", "hl.exec_cmd('blueman-manager', {tag='shell'})"])
}
