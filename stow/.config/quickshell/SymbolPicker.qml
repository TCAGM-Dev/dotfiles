import Quickshell
import Quickshell.Io
import QtQml 2.15
import "levenshtein.js" as Levenshtein

LauncherWindow {
	id: picker

	showIcons: false

	property list<var> entries: []
	viewEntries: runSearch(picker.searchText).slice(0, 30)
	function runSearch(query: string): list<var> {
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
	}

	function openPicker(file: string) {
		reader.filePath = file
		reader.running = true
	}

	onIsOpenChanged: () => {
		if (!this.isOpen) picker.entries = []
	}

	Process {
		id: reader

		property string filePath

		running: false
		command: ["cat", this.filePath]
		
		stdout: StdioCollector {
			onStreamFinished: () => {
				const content = this.text

				let lines = content.split("\n")
				lines = lines.map(line => {
					const commentIndex = line.indexOf("#")
					if (commentIndex == -1) return line
					else return line.slice(0, commentIndex)
				})
				lines = lines.map(line => line.trim())
				lines = lines.filter(line => line != "")

				picker.entries = lines.map(line => {
					const [symbol, searchString] = line.split(",")

					return {
						display: `${symbol} ${searchString}`,
						name: searchString,
						onSelect: () => {
							Quickshell.execDetached(["wl-copy", symbol])
							Quickshell.execDetached(["notify-send", `Copied "${symbol}"`])
						}
					}
				})
				picker.open()
			}
		}
	}
}