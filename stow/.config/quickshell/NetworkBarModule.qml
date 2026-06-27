import Quickshell.Networking
import QtQuick 2.0

BarModule {
	readonly property list<NetworkDevice> connectedDevices: Networking.devices.values.filter(d => d.connected)
	readonly property list<Network> connectedNetworks: connectedDevices.reduce((acc, device) => {
		const networks = device.networks.values.filter(n => n.connected)
		return acc.concat(networks)
	}, [])
	readonly property Network primaryNetwork: connectedNetworks[0] // TODO: Find way to improve this, currently decidec by the order of connectedDevices

	readonly property int connectivity: Networking.connectivity

	function sampleArray(arr: list<var>, t: real): var {
		return arr[Math.min(Math.round(t * arr.length), arr.length - 1)]
	}

	readonly property var connectivityData: (() => {
		const result = new Map()

		result.set(NetworkConnectivity.Portal, {text: "Authenticate"})
		result.set(NetworkConnectivity.Full, {text: primaryNetwork?.name ?? "", icon: (() => {
			if (primaryNetwork instanceof WifiNetwork) return sampleArray(connectivity == NetworkConnectivity.Full ? ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"] : ["󰤫", "󰤠", "󰤣", "󰤦", "󰤩"], primaryNetwork.signalStrength)
			return ""
		})()})
		result.set(NetworkConnectivity.Limited, result.get(NetworkConnectivity.Full))
		result.set(NetworkConnectivity.Unknown, {text: "Unknown", color: "#aaaaaa"})
		result.set(NetworkConnectivity.None, {icon: "󰤭", color: "#aaaaaa"})

		return result
	})()
	readonly property var currentData: connectivityData.get(connectivity)

	visible: currentData != null

	Component.onCompleted: Networking.checkConnectivity()
	text: [currentData.icon, currentData.text].filter(v => v != null).join(" ")
	color: currentData.color ?? "white"

	onClicked: () => Quickshell.execDetached(["networkmanager_dmenu"])
}