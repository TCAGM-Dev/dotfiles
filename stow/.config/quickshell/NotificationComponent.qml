import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: root
	required property Notification notification
	required property real timeoutMs

	readonly property Region region: notificationRegion
	Region {
		id: notificationRegion
		item: root
		radius: root.radius
	}

	color: notification.urgency == NotificationUrgency.Critical ? "#7f570000" : "#80000000"
	border.color: notification.urgency == NotificationUrgency.Critical ? "#ff1212" : notification.urgency == NotificationUrgency.Low ? "#595959" : "white"
	radius: 6

	height: notificationContent.height

	Layout.alignment: Qt.AlignRight | Qt.AlignTop

	MouseArea {
		anchors.fill: parent

		onClicked: e => {
			if (e.button == Qt.RightButton) root.notification.dismiss()
		}

		onDoubleClicked: e => {
			const actions = root.notification.actions
			if (actions.length > 1) {
				NotificationActionListOpener.open(actions)
			} else if (actions.length == 1) {
				actions[0].invoke()
			}
		}

		HoverHandler {
			id: hover
			cursorShape: Qt.PointingHandCursor
		}
	}

	ColumnLayout {
		id: notificationContent

		width: parent.width

		RowLayout {
			Layout.preferredHeight: Math.max(image.height, textArea.height)

			spacing: 0

			Image {
				id: image

				source: root.notification.image
				visible: root.notification.image != ""

				fillMode: Image.PreserveAspectFit

				Layout.preferredWidth:  100
				Layout.preferredHeight: 100
			}

			ColumnLayout {
				id: textArea

				spacing: -11

				Text {
					text: root.notification.summary
					visible: this.text != ""

					color: "white"
					font.family: "Adwaita Mono"
					font.pixelSize: 15
					font.bold: true

					renderType: Text.NativeRendering

					Layout.fillWidth: true
					padding: 7
					elide: Text.ElideRight
				}

				Text {
					text: root.notification.body
					visible: this.text != ""

					color: "#e0e0e0"
					font.family: "Adwaita Mono"
					font.pixelSize: 15

					renderType: Text.NativeRendering

					Layout.fillWidth: true
					padding: 7
					wrapMode: Text.Wrap
				}
			}
		}
	}

	Timer {
		running: root.notification.urgency != NotificationUrgency.Critical && !hover.hovered

		interval: root.timeoutMs

		onTriggered: root.notification.expire()
	}
}