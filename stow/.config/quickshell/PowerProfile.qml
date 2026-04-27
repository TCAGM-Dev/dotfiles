pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property string activeProfile: "balanced" // Assume balanced at first to avoid errors

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
				notifier.running = true

				const parts = this.text.split(" ")

				const interface = parts[1].slice(1, -1)
				const propertyName = parts[3].slice(1, -1)
				const propertyType = parts[4]
				const propertyValue = parts[5]

				if (
					interface == "net.hadess.PowerProfiles" &&
					propertyName == "ActiveProfile" &&
					propertyType == "s"
				) root.activeProfile = propertyValue.slice(1, -1)
			}
		}
	}

	onActiveProfileChanged: () => Quickshell.execDetached(["powerprofilesctl", "set", root.activeProfile])
}
