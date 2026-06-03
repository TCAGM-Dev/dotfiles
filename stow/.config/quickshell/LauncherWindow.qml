pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick.Layouts
import "levenshtein.js" as Levenshtein

PanelWindow {
	id: root
	WlrLayershell.namespace: "quickshell_launcher"
	HyprlandWindow.visibleMask: Region {
		item: windowFrameRectangle // Limit hyprland background blur effect to the actually filled part
	}
	exclusionMode: ExclusionMode.Ignore

	property var gatherEntries
	property list<var> entries
	property var overrideEntries
	readonly property list<var> viewEntries: (overrideEntries?.(search.text) ?? ((query) => {
		if (query == "") return entries

		query = query.toLowerCase()

		const queryItems = query.split(" ").filter(v => v.length > 0)
		const result = entries.filter(entry => {
			const matcher = (entry.meta == null ? entry.name : `${entry.name} ${entry.meta}`).toLowerCase()
			return queryItems.some(q => q.includes(matcher) || matcher.includes(q))
		})
	
		const distances = {}
		for (const entry of result) {
			distances[entry] = Math.min(...(entry.name).toLowerCase().split(" ").map(word => Levenshtein.distance(word, query)))
		}
		result.sort((a, b) => distances[a] - distances[b])
	
		return result
	})(search.text)).slice(0, 30)
	property bool showIcons: true

	implicitWidth: 600
	anchors.top: true
	anchors.bottom: true
	implicitHeight: WlrLayershell.screen.height
	property string fontFamily: "Adwaita Mono"

	focusable: true
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

	WlrLayershell.layer: WlrLayer.Overlay

	color: "transparent"

	function tryGatherEntries() {
		if (root.gatherEntries != null) root.entries = root.gatherEntries() ?? root.entries
	}
	Component.onCompleted: tryGatherEntries()
	property bool isOpen: false
	function open() {
		search.clear()
		search.forceActiveFocus()
		tryGatherEntries()
		isOpen = true
	}
	function close() {
		isOpen = false
		root.entries = []
	}
	visible: isOpen

	readonly property list<int> shortcutNumbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

	Frame {
		id: frame
		property bool isCtrlPressed: false
		Keys.onPressed: event => {if (event.key === Qt.Key_Control) isCtrlPressed = true}
		Keys.onReleased: event => {if (event.key === Qt.Key_Control) isCtrlPressed = false}

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
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
					root.viewEntries[0]?.onSelect?.()
					root.close()
				}
				Keys.onPressed: (event) => {
					if (!frame.isCtrlPressed) return
					const keyNum = event.key - Qt.Key_0
					if (keyNum < 0 || keyNum >= root.shortcutNumbers.length) return
					const index = root.shortcutNumbers.indexOf(keyNum)
					entriesRepeater.itemAt(index).activate()
					frame.isCtrlPressed = false
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

						Text {
							text: `CTRL+${root.shortcutNumbers[item.index]}`
							visible: frame.isCtrlPressed && item.index < root.shortcutNumbers.length
							font.family: root.fontFamily
							font.pointSize: 9
							renderType: Text.NativeRendering
							color: "#777777"
						}
					}
				}
			}
		}
	}
}