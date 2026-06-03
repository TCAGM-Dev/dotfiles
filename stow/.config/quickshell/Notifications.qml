pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
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

	Process {
		id: actionsListOpener

		running: false

		property list<NotificationAction> actions

		command: ["bash", "-c", `echo -en "${actions.map(a => `${a.identifier}\\0display\\x1f${a.text}`).join("\\n")}" | dmenu`]

		stdout: StdioCollector {
			onStreamFinished: () => {
				const identifier = this.text.slice(0, -1)
				const action = actionsListOpener.actions.find(a => a.identifier == identifier)
				if (action == null) return
				action.invoke()
			}
		}
	}

	Variants {
		model: Quickshell.screens

		delegate: PanelWindow {
			WlrLayershell.namespace: "quickshell_notifications"
			required property var modelData
			screen: modelData

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

					Rectangle {
						id: notificationItem
						required property Notification modelData

						readonly property Region region: notificationRegion
						Region {
							id: notificationRegion
							item: notificationItem
							radius: notificationItem.radius
						}

						color: modelData.urgency == NotificationUrgency.Critical ? "#7f570000" : "#80000000"
						border.color: modelData.urgency == NotificationUrgency.Critical ? "#ff1212" : modelData.urgency == NotificationUrgency.Low ? "#595959" : "white"
						radius: 6

						width: parent.width
						height: notificationContent.height

						Layout.alignment: Qt.AlignRight | Qt.AlignTop

						MouseArea {
							anchors.fill: parent

							onClicked: e => {
								if (e.button == Qt.RightButton) notificationItem.modelData.dismiss()
							}

							onDoubleClicked: e => {
								if (notificationItem.modelData.actions.length > 0 && !actionsListOpener.running) {
									actionsListOpener.actions = notificationItem.modelData.actions
									actionsListOpener.running = true
								}
							}

							HoverHandler {
								id: hover
								cursorShape: Qt.PointingHandCursor
							}
						}

						RowLayout {
							id: notificationContent

							width: parent.width
							height: Math.max(image.height, textArea.height)

							spacing: 0

							Image {
								id: image

								source: notificationItem.modelData.image
								visible: notificationItem.modelData.image != ""

								Layout.preferredWidth:  100
								Layout.preferredHeight: 100
							}

							ColumnLayout {
								id: textArea

								spacing: -11

								Layout.fillWidth: true

								Text {
									text: notificationItem.modelData.summary
									visible: this.text != ""

									color: "white"
									font.family: "Adwaita Mono"
									font.pixelSize: 15
									font.bold: true

									renderType: Text.NativeRendering

									Layout.fillWidth: true
									padding: 7
								}

								Text {
									text: notificationItem.modelData.body
									visible: this.text != ""

									color: "#e0e0e0"
									font.family: "Adwaita Mono"
									font.pixelSize: 15

									renderType: Text.NativeRendering

									Layout.fillWidth: true
									Layout.fillHeight: true
									padding: 7
									wrapMode: Text.Wrap
								}
							}
						}

						Timer {
							running: notificationItem.modelData.urgency != NotificationUrgency.Critical && !hover.hovered

							interval: root.timeoutMs

							onTriggered: notificationItem.modelData.expire()
						}
					}
				}
			}
		}
	}
}
