pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: qalc

	property string expression
	property string output

	function calculate(expression: string): string {
		qalc.expression = expression	
		process.running = true
		return qalc.output
	}

	Process {
		id: process

		running: false
		command: ["qalc", qalc.expression]
		stdout: StdioCollector {
			onStreamFinished: qalc.output = this.text.slice(0, this.text.length - 1)
		}
	}
}
