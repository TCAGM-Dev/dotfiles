pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property string activeProfile

	Process {
		id: retrieval
		running: true
		command: ["powerprofilesctl", "get"]
		stdout: StdioCollector {
			onStreamFinished: () => root.activeProfile = this.text.slice(0, -1)
		}
	}

	Process {
		id: notifier
		running: true
		command: ["busctl", "--system", "wait", "net.hadess.PowerProfiles", "/net/hadess/PowerProfiles", "org.freedesktop.DBus.Properties", "PropertiesChanged"]
		stdout: StdioCollector {
			onStreamFinished: () => {
				retrieval.running = true
				notifier.running = true
			}
		}
	}

	onActiveProfileChanged: () => Quickshell.execDetached(["powerprofilesctl", "set", root.activeProfile])
}
