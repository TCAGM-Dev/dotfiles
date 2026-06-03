pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
	id: root

	function open(actions) { // Adding typedef makes the list empty?
		if (opener.running) return
		opener.actions = actions
		opener.running = true
	}

	Process {
		id: opener

		property list<NotificationAction> actions

		running: false

		command: ["bash", "-c", `echo -en "${actions.map(a => `${a.identifier}\\0display\\x1f${a.text}`).join("\\n")}" | dmenu`]

		stdout: StdioCollector {
			onStreamFinished: () => {
				const identifier = this.text.slice(0, -1)
				const action = opener.actions.find(a => a.identifier == identifier)
				if (action == null) return
				action.invoke()
			}
		}
	}
}