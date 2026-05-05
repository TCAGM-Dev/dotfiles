pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
	id: root
	WlrLayershell.namespace: "quickshell_launcher"

	required property list<var> viewEntries
	property var beforeOpen
	property alias searchText: search.text
	property bool showIcons: true

	implicitWidth: 600
	implicitHeight: getHeight()
	function getHeight(): real {
		let h = 0

		h += 2 // border
		for (let child of column.children) {
			h += child.height
		}

		return h
	}

	property string fontFamily: "Adwaita Mono"

	focusable: true
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

	WlrLayershell.layer: WlrLayer.Overlay

	color: "transparent"

	property bool isOpen: false
	function open() {
		search.clear()
		search.forceActiveFocus()
		root.beforeOpen?.()
		isOpen = true
	}
	function close() {isOpen = false}
	visible: isOpen

	Frame {
		anchors.fill: parent
		padding: 1 // exclude border

		background: Rectangle {
			id: windowFrameRectangle
			color: "#80000000"
			border.color: "white"
			radius: 6
		}

		Column {
			id: column

			anchors.fill: parent
			anchors.margins: 0

			TextField {
				id: search

				width: parent.width

				Keys.onEscapePressed: root.close()
				Keys.onDownPressed: () => {
					const entryItem = entriesRepeater.itemAt(1) ?? entriesRepeater.itemAt(0)
					if (entryItem != null) entryItem.forceActiveFocus()
				}
				Keys.onReturnPressed: () => {
					root.viewEntries[0]?.onSelect()
					root.close()
				}

				background: Rectangle {
					color: "#171717"
					topLeftRadius: windowFrameRectangle.radius - 1
					topRightRadius: windowFrameRectangle.radius - 1
					bottomLeftRadius: root.viewEntries.length > 0 ? 0 : windowFrameRectangle.radius - 1
					bottomRightRadius: root.viewEntries.length > 0 ? 0 : windowFrameRectangle.radius - 1
				}

				color: "white"
				font.family: root.fontFamily
				font.pointSize: 11
				renderType: Text.NativeRendering
				padding: 5
			}

			Rectangle {
				visible: root.viewEntries.length > 0
				implicitWidth: parent.width
				implicitHeight: 1
				color: "#595959"
			}

			Repeater {
				id: entriesRepeater
				model: root.viewEntries
				Button {
					id: item
					required property int index
					required property var modelData

					Keys.onEscapePressed: search.forceActiveFocus()
					
					function activate() {
						modelData.onSelect()
						root.close()
					}
					onClicked: item.activate()
					Keys.onReturnPressed: item.activate()
					Keys.onEnterPressed: item.activate()

					Keys.onUpPressed: () => {
						const target = entriesRepeater.itemAt(index - 1)
						if (target != null) target.forceActiveFocus()
					}
					Keys.onDownPressed: () => {
						const target = entriesRepeater.itemAt(index + 1)
						if (target != null) target.forceActiveFocus()
					}

					width: parent.width
					background: Rectangle {
						visible: parent.activeFocus || item.hovered || (search.activeFocus && item.index == 0)
						color: "#4d939393"
					}
					contentItem: RowLayout {
						Image {
							visible: root.showIcons
							Layout.preferredHeight: itemText.height
							Layout.preferredWidth: itemText.height
							source: item.modelData.iconSource ?? ""
							mipmap: true
							fillMode: Image.PreserveAspectFit
							asynchronous: true
						}

						Text {
							id: itemText
							text: item.modelData.display ?? item.modelData.name
							Layout.fillWidth: true
							font.family: root.fontFamily
							font.pointSize: 11
							renderType: Text.NativeRendering
							color: "white"
						}
					}
				}
			}
		}
	}
}
