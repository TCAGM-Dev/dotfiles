pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root

	property string currentDate: ""
	property string currentTime: ""

	Process {
		id: process

		command: ["date", "+\"%d-%m-%y%n%H:%M\""]
		running: true

		stdout: StdioCollector {
			onStreamFinished: () => {
				const lines = this.text.slice(1, -2).split("\n")
				root.currentDate = lines[0]
				root.currentTime = lines[1]
			}
		}
	}

	Timer {
		interval: 10000 // Every 10 seconds
		running: true
		repeat: true
		onTriggered: process.running = true
	}
}
