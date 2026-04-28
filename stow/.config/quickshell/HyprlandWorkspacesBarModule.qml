import Quickshell.Hyprland
import QtQuick

Row {
	id: module

	property HyprlandMonitor monitor

	Repeater {
		model: Hyprland.workspaces.values
			.filter(w => w.id >= 0) // Hide special workspaces
			.filter(w => w.monitor === module.monitor || module.monitor == null)

		delegate: BarModule {
			required property var modelData

			text: modelData.id
			implicitWidth: 24
			glow: modelData === Hyprland.focusedWorkspace

			onClicked: () => Hyprland.dispatch(`focusworkspaceoncurrentmonitor ${modelData.id}`)
		}
	}
}
