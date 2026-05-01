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

	signal rightClicked()
	signal middleClicked()

	MouseArea {
		anchors.fill: parent

		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

		onClicked: e => {
			if (e.button == Qt.LeftButton) module.clicked()
			else if (e.button == Qt.RightButton) module.rightClicked()
			else if (e.button == Qt.MiddleButton) module.middleClicked()
		}

		HoverHandler {
			cursorShape: Qt.PointingHandCursor
		}
	}

	contentItem: ColumnLayout {
		spacing: module.gap
		width: label.width

		Label {
			id: label
			text: module.text

			font: module.font
			renderType: Text.NativeRendering // Improve legibility, for some reason the default is just bad

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
