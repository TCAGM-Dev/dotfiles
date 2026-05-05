import Quickshell
import QtQuick
import Quickshell.Io
import "levenshtein.js" as Levenshtein

Scope {
	SymbolPicker {
		id: picker
	}

	LauncherWindow {
		id: launcher
	
		property list<var> entries: []
		beforeOpen: () => gatherEntries()
		Component.onCompleted: () => gatherEntries() // Fix desktop files not showing up on first open
		function gatherEntries() {
			const result = []
			const home = Quickshell.env("HOME")
			
			for (const desktopEntry of DesktopEntries.applications.values) {
				if (desktopEntry.noDisplay == true) continue
				result.push({
					id: `desktop:${desktopEntry.id}`,
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
			result.push({id: "power:lock", name: "Lock", onSelect: () => Quickshell.execDetached(["bash", "-c", "playerctl -a pause; hyprlock"])})
			result.push({id: "power:sleep", name: "Sleep", onSelect: () => Quickshell.execDetached(["systemctl", "sleep"])})
			result.push({id: "power:logout", name: "Logout", onSelect: () => Quickshell.execDetached(["bash", "-c", "hyprshutdown && hyprshutdown || hyprctl dispatch exit"])})
			result.push({id: "power:reboot", name: "Reboot", onSelect: () => Quickshell.execDetached(["systemctl", "reboot"])})
			result.push({id: "power:shutdown", name: "Shutdown", onSelect: () => Quickshell.execDetached(["systemctl", "poweroff"])})
	
			// Power profiles
			result.push({id: "power_profile:power-saver", display: "Power profile: Ecological", name: "eco mode", onSelect: () => PowerProfile.activeProfile = "power-saver"})
			result.push({id: "power_profile:balanced", display: "Power profile: Balanced", name: "balanced mode", onSelect: () => PowerProfile.activeProfile = "balanced"})
			result.push({id: "power_profile:performance", display: "Power profile: Performance", name: "performance mode", onSelect: () => PowerProfile.activeProfile = "performance"})

			// Symbol picker
			result.push({id: "symbol:nerd", name: "Nerd Symbol picker", onSelect: () => {launcher.close(); picker.openPicker(`${home}/.config/rofi/scripts/nerd_symbols.txt`)}})
			result.push({id: "symbol:emoji", name: "Emoji picker", onSelect: () => {launcher.close(); picker.openPicker(`${home}/.config/rofi/scripts/emojis.txt`)}})

			for (const entry of result) if (entry.id == null) console.error(`No id found in entry: ${entry}`) // Failsafe to prevent entries without ids to ever be added
	
			launcher.entries = result
		}
		viewEntries: runSearch(launcher.searchText)
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
