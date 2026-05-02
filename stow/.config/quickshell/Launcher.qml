import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Io
import "levenshtein.js" as Levenshtein

PanelWindow {
	id: launcher
	WlrLayershell.namespace: "quickshell_launcher"

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
				name: desktopEntry.name,
				meta: [desktopEntry.genericName, desktopEntry.execString, desktopEntry.categories.join(" "), desktopEntry.keywords.join(" ")].filter(v => v != null && v != "").join(" "),
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

		// Power profiles
		result.push({display: "Power profile: Ecological", name: "eco mode", onSelect: () => PowerProfile.activeProfile = "power-saver"})
		result.push({display: "Power profile: Balanced", name: "balanced mode", onSelect: () => PowerProfile.activeProfile = "balanced"})
		result.push({display: "Power profile: Performance", name: "performance mode", onSelect: () => PowerProfile.activeProfile = "performance"})

		launcher.entries = result
	}
	property var viewEntries: runSearch(search.text)
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
			const home = Quickshell.env("HOME")
			return [
				{name: "Search on DuckDuckGo", onSelect: () => Quickshell.execDetached(["xdg-open", `https://duckduckgo.com/?q=${encodedSearchQuery}`]), iconSource: `${home}/.local/share/icons/duckduckgo.png`},
				{name: "Search on Google", onSelect: () => Quickshell.execDetached(["xdg-open", `https://www.google.com/search?q=${encodedSearchQuery}`]), iconSource: `${home}/.local/share/icons/google.png`},
				{name: "Search on ArchWiki", onSelect: () => Quickshell.execDetached(["xdg-open", `https://wiki.archlinux.org/index.php?search=${encodedSearchQuery}`]), iconSource: `${home}/.local/share/icons/arch.png`},
				{name: "Search on MDN", onSelect: () => Quickshell.execDetached(["xdg-open", `https://developer.mozilla.org/search?q=${encodedSearchQuery}`]), iconSource: `${home}/.local/share/icons/mdn.png`},
			]
		}
		if (query.startsWith(":")) {
			let uri = query.slice(1)
			if (uri.startsWith("~")) uri = Quickshell.env("HOME") + uri.slice(1)
			return [
				{name: `Open "${uri}"`, onSelect: () => Quickshell.execDetached(["xdg-open", uri])},
			]
		}
		
		query = query.toLowerCase()

		const queryItems = query.split(" ").filter(v => v.length > 0)
		const result = query == "" ? entries : entries.filter(entry => {
			const matcher = (entry.meta == null ? entry.name : `${entry.name} ${entry.meta}`).toLowerCase()
			return queryItems.some(q => q.includes(matcher) || matcher.includes(q))
		})

		for (const entry of result) {
			entry.distance = Math.min(...(entry.name).toLowerCase().split(" ").map(word => Levenshtein.distance(word, query)))
		}
		result.sort((a, b) => a.distance - b.distance)

		return result
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
				renderType: Text.NativeRendering
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
							renderType: Text.NativeRendering
							color: "white"
						}
					}
				}
			}
		}
	}
}
