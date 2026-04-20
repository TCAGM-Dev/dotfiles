import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Io

PanelWindow {
	id: launcher

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

	property bool isOpen: false
	function open() {
		search.clear()
		search.forceActiveFocus()
		gatherEntries()
		isOpen = true
	}
	function close() {isOpen = false}
	visible: isOpen

	property var entries: []
	function gatherEntries() {
		const result = []
		
		for (const desktopEntry of DesktopEntries.applications.values) {
			if (desktopEntry.noDisplay == true) continue
			result.push({
				display: `${desktopEntry.name}${desktopEntry.genericName == "" ? "" : ` (${desktopEntry.genericName})`}`,
				name: [desktopEntry.name, desktopEntry.genericName, desktopEntry.execString, desktopEntry.categories.join(" "), desktopEntry.keywords.join(" ")].filter(v => v != null && v != "").join(" "),
				onSelect: () => {
					if (desktopEntry.runInTerminal) { // desktopEntry.execute() doesnt respect Terminal=true
						Quickshell.execDetached(["kitty", "sh", "-c", desktopEntry.execString])
					} else {
						desktopEntry.execute()
					}
				},
				iconSource: desktopEntry.icon.startsWith("/") ? desktopEntry.icon : Quickshell.iconPath(desktopEntry.icon, true)
			})
		}
		
		// Power options
		result.push({name: "Lock", onSelect: () => Quickshell.execDetached(["bash", "-c", "playerctl -a pause; hyprlock"])})
		result.push({name: "Sleep", onSelect: () => Quickshell.execDetached(["systemctl", "sleep"])})
		result.push({name: "Logout", onSelect: () => Quickshell.execDetached(["bash", "-c", "hyprshutdown && hyprshutdown || hyprctl dispatch exit"])})
		result.push({name: "Reboot", onSelect: () => Quickshell.execDetached(["systemctl", "reboot"])})
		result.push({name: "Shutdown", onSelect: () => Quickshell.execDetached(["systemctl", "poweroff"])})

		launcher.entries = result
	}
	property var viewEntries: search.text == null ? entries : runSearch(search.text)
	function runSearch(query: string): list<var> {
		if (query.startsWith("!")) {
			const command = query.slice(1)
			return [
				{name: `Execute "${command}"`, onSelect: () => Quickshell.execDetached(["sh", "-c", command])},
				{name: "Run in kitty", onSelect: () => Quickshell.execDetached(["kitty", "sh", "-c", command])},
			]
		}
		if (query.startsWith("=")) {
			const expression = query.slice(1)
			if (expression == "") return []
			const output = Qalc.calculate(expression)
			let equalsIndex = output.indexOf("= ")
			if (equalsIndex == -1) equalsIndex = output.indexOf("≈ ")
			if (equalsIndex == -1) return []
			const result = output.slice(equalsIndex + 2)
			return [
				{name: output, onSelect: () => Quickshell.execDetached(["wl-copy", "--", result])}
			]
		}
		if (query.startsWith("?")) {
			const searchQuery = query.slice(1)
			const encodedSearchQuery = encodeURIComponent(searchQuery)
			return [
				{name: "Search on DuckDuckGo", onSelect: () => Quickshell.execDetached(["xdg-open", `https://duckduckgo.com/?q=${encodedSearchQuery}`])},
				{name: "Search on Google", onSelect: () => Quickshell.execDetached(["xdg-open", `https://www.google.com/search?q=${encodedSearchQuery}`])},
				{name: "Search on Bing", onSelect: () => Quickshell.execDetached(["xdg-open", `https://www.bing.com/search?q=${encodedSearchQuery}`])},
				{name: "Search on MDN", onSelect: () => Quickshell.execDetached(["xdg-open", `https://developer.mozilla.org/search?q=${encodedSearchQuery}`])},
			]
		}
		if (query.startsWith(":")) {
			const uri = query.slice(1)
			return [
				{name: `Open "${uri}"`, onSelect: () => Quickshell.execDetached(["xdg-open", uri])},
			]
		}

		const queryItems = query.toLowerCase().split(" ").filter(v => v.length > 0)
		return entries.filter(entry => {
			const name = entry.name.toLowerCase()
			return queryItems.some(q => q.includes(name) || name.includes(q))
		})
	}

	focusable: true
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

	WlrLayershell.layer: WlrLayer.Overlay

	color: "transparent"

	IpcHandler {
		target: "launcher"

		function open() {
			launcher.open()
		}
		function close() {
			launcher.close()
		}
	}

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

				Keys.onEscapePressed: launcher.close()
				Keys.onDownPressed: () => {
					const entryItem = entriesRepeater.itemAt(1) ?? entriesRepeater.itemAt(0)
					if (entryItem != null) entryItem.forceActiveFocus()
				}
				Keys.onReturnPressed: () => {
					launcher.viewEntries[0]?.onSelect()
					launcher.close()
				}

				background: Rectangle {
					color: "#171717"
					topLeftRadius: windowFrameRectangle.radius - 1
					topRightRadius: windowFrameRectangle.radius - 1
					bottomLeftRadius: launcher.viewEntries.length > 0 ? 0 : windowFrameRectangle.radius - 1
					bottomRightRadius: launcher.viewEntries.length > 0 ? 0 : windowFrameRectangle.radius - 1
				}

				color: "white"
				font.family: launcher.fontFamily
				font.pointSize: 11
				padding: 5
			}

			Rectangle {
				visible: launcher.viewEntries.length > 0
				implicitWidth: parent.width
				implicitHeight: 1
				color: "#595959"
			}

			Repeater {
				id: entriesRepeater
				model: launcher.viewEntries
				Button {
					id: item
					required property int index
					required property var modelData

					Keys.onEscapePressed: search.forceActiveFocus()
					
					function activate() {
						modelData.onSelect()
						launcher.close()
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
					contentItem: Row {
						Image {
							height: parent.height
							width: height
							source: item.modelData.iconSource ?? ""
							mipmap: true
							fillMode: Image.PreserveAspectFit
							asynchronous: true
						}

						Rectangle {
							width: 2
							height: parent.height
							color: "transparent"
						}

						Text {
							text: item.modelData.display ?? item.modelData.name
							font.family: launcher.fontFamily
							font.pointSize: 11
							color: "white"
						}
					}
				}
			}
		}
	}
}
