pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Item {
	id: root

	required property string wallpaperPath

	IpcHandler {
		target: "wallpaper"

		function setWallpaper(path: string) {
			root.wallpaperPath = path
		}
	}

	Variants {
		model: Quickshell.screens

		delegate: PanelWindow {
			WlrLayershell.layer: WlrLayer.Background

			required property var modelData
			screen: this.modelData

			anchors.top: true
			anchors.bottom: true
			anchors.left: true
			anchors.right: true

			exclusionMode: ExclusionMode.Ignore

			Image {
				source: root.wallpaperPath

				anchors.fill: parent

				fillMode: Image.PreserveAspectCrop
			}
		}
	}
}