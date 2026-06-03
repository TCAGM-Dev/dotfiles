import Quickshell
import Quickshell.Io
import QtQml 2.15

LauncherWindow {
	id: picker

	showIcons: false

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