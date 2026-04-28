import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Variants {
	model: Quickshell.screens

	delegate: PanelWindow {
		id: bar

		required property var modelData
		screen: modelData

		anchors.left: true
		anchors.bottom: true
		anchors.right: true

		property real gap: 10

		color: "transparent"

		implicitHeight: Math.max(left.height, center.height, right.height)

		Rectangle {
			anchors.fill: parent
			gradient: LinearGradient {
				GradientStop {position: 1; color: "#b3000000"}
				GradientStop {position: 0; color: "transparent"}
			}
		}

		RowLayout {
			id: left

			anchors.bottom: parent.bottom
			anchors.left: parent.left
			spacing: bar.gap

			PowerProfileBarModule {}
		}

		RowLayout {
			id: center

			anchors.bottom: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: bar.gap

			HyprlandWorkspacesBarModule {
				monitor: Hyprland.monitorFor(bar.screen)
			}
		}

		RowLayout {
			id: right

			anchors.bottom: parent.bottom
			anchors.right: parent.right
			spacing: bar.gap

			ClockBarModule {}
		}
	}
}
