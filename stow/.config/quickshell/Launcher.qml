import Quickshell
import QtQuick
import Quickshell.Io

Scope {
	SymbolPicker {
		id: picker
	}

	LauncherWindow {
		id: launcher
	
		gatherEntries: () => {
			const result = []
			const home = Quickshell.env("HOME")
			
			for (const desktopEntry of DesktopEntries.applications.values) {
				if (desktopEntry.noDisplay == true) continue
				result.push({
					display: `${desktopEntry.name}${desktopEntry.genericName == "" ? "" : ` (${desktopEntry.genericName})`}`,
					name: desktopEntry.name,
					meta: [desktopEntry.genericName, desktopEntry.execString, desktopEntry.categories.join(" "), desktopEntry.keywords.join(" ")].filter(v => v != null && v != "").join(" "),
					onSelect: () => {
						if (desktopEntry.runInTerminal) { // desktopEntry.execute() doesnt respect Terminal=true
							Quickshell.execDetached(["kitty", "sh", "-c", desktopEntry.command])
						} else {
							desktopEntry.execute()
						}
					},
					iconSource: desktopEntry.icon.startsWith("/") ? desktopEntry.icon : Quickshell.iconPath(desktopEntry.icon, true)
				})
			}
			
			// Power options
			result.push({name: "Lock", onSelect: () => Quickshell.execDetached(["bash", "-c", "playerctl -a pause; hyprlock"])})
			result.push({name: "Sleep", meta: "suspend", onSelect: () => Quickshell.execDetached(["systemctl", "sleep"])})
			result.push({name: "Logout", onSelect: () => Quickshell.execDetached(["bash", "-c", "hyprshutdown && hyprshutdown || hyprctl dispatch exit"])})
			result.push({name: "Reboot", meta: "restart", onSelect: () => Quickshell.execDetached(["systemctl", "reboot"])})
			result.push({name: "Shutdown", meta: "power off", onSelect: () => Quickshell.execDetached(["systemctl", "poweroff"])})
	
			// Power profiles
			result.push({display: "Power profile: Ecological", name: "eco mode", onSelect: () => PowerProfile.activeProfile = "power-saver"})
			result.push({display: "Power profile: Balanced", name: "balanced mode", onSelect: () => PowerProfile.activeProfile = "balanced"})
			result.push({display: "Power profile: Performance", name: "performance mode", onSelect: () => PowerProfile.activeProfile = "performance"})

			// Symbol picker
			result.push({name: "Nerd Symbol picker", onSelect: () => {launcher.close(); picker.openPicker(`${home}/.config/quickshell/symbols/nerd_symbols.txt`)}})
			result.push({name: "Emoji picker", onSelect: () => {launcher.close(); picker.openPicker(`${home}/.config/quickshell/symbols/emojis.txt`)}})
			result.push({name: "Kaomoji picker", meta: "text face unicode emoji", onSelect: () => {launcher.close(); picker.openPicker(`${home}/.config/quickshell/symbols/kaomojis.txt`)}})

			launcher.entries = result
		}
		overrideEntries: (query) => {
			if (query == "") return []
			else if (query == "*") return entries

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
		}
	
		IpcHandler {
			target: "launcher"
	
			function open() {
				launcher.open()
			}
			function close() {
				launcher.close()
			}
		}
	}
}