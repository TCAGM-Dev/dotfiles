pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "util.js" as Util

Item {
	id: root
	property real timeoutMs: 10000

	NotificationServer {
		id: server

		actionsSupported: true

		onNotification: notification => {
			notification.tracked = true
		}
	}

	Variants {
		model: Quickshell.screens

		delegate: PanelWindow {
			WlrLayershell.namespace: "quickshell_notifications"
			required property var modelData
			screen: modelData

			visible: server.trackedNotifications.values.length > 0

			anchors.right: true
			anchors.top: true
			anchors.bottom: true

			implicitWidth: 350
			exclusionMode: ExclusionMode.Ignore

			color: "transparent"

			mask: Region {
				regions: Util.range(notificationRepeater.count).map(i => notificationRepeater.itemAt(i)?.region).filter(v => v != null) // 💀
			}
			HyprlandWindow.visibleMask: this.mask

			ColumnLayout {
				id: notificationColumn

				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right

				spacing: 10

				Repeater {
					id: notificationRepeater
					model: server.trackedNotifications
					
					NotificationComponent {
						required property Notification modelData
						notification: modelData
						timeoutMs: modelData.expireTimeout != -1 ? modelData.expireTimeout : root.timeoutMs
						width: parent.width
					}
				}
			}
		}
	}
}