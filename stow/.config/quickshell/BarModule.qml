import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Button {
	id: module

	property int lineWidth: 3
	property bool glow: false
	property string color: "white"
	property real gap: 2

	padding: 0
	Layout.alignment: Qt.AlignBottom

	font.family: "Adwaita Mono"
	font.pixelSize: 17

	HoverHandler {
		cursorShape: Qt.PointingHandCursor
	}

	contentItem: ColumnLayout {
		spacing: module.gap
		width: label.width

		Label {
			id: label
			text: module.text

			font: module.font

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			Layout.alignment: Qt.AlignHCenter

			color: module.color
		}

		Rectangle {
			id: bottomLine

			implicitWidth: parent.width
			implicitHeight: module.lineWidth

			color: module.color
		}
	}

	background: Rectangle {
		anchors.fill: parent
		visible: module.glow
		gradient: LinearGradient {
			GradientStop {position: 1; color: "#b3c8c8c8"}
			GradientStop {position: 0; color: "transparent"}
		}
	}
}
