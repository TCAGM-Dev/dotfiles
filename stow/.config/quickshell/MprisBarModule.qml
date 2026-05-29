import Quickshell.Services.Mpris
import Quickshell.Hyprland
import QtQuick

BarModule {
	id: module

	required property HyprlandMonitor monitor
	property int maxLength
	property string ellipsis: ".."

	property list<string> ignored: []
	property var playerIcons: {
		"spotify": "",
		"firefox": "󰈹",
		"cliamp":  "",
		"default": "",
	}

	function formatLength(length: real): string {
		const minutes = Math.floor(length / 60)
		const seconds = Math.floor(length % 60)
		return `${minutes}:${seconds < 10 ? `0${seconds}` : seconds}`
	}

	readonly property list<MprisPlayer> players: Mpris.players.values.filter(player => !module.ignored.includes(player.desktopEntry))
	readonly property MprisPlayer player: players[0]

	visible: player != null

	Timer {
		id: lengthRefresher

		running: module.player.playbackState == MprisPlaybackState.Playing && !module.monitor.activeWorkspace.hasFullscreen

		interval: 1000
		repeat: true

		onTriggered: module.player.positionChanged()
	}

	Timer {
		id: idleCloser

		running: module.player.playbackState != MprisPlaybackState.Playing

		interval: 30000
		repeat: false

		onTriggered: module.open = false
	}

	onWheel: e => {
		if (!module.open) return
		if (e.angleDelta.y > 0) player.previous()
		else if (e.angleDelta.y < 0) player.next()
	}

	property bool open: true

	function getMediaDescription(artist: string, title: string): string {
		if (artist == "" || artist == null) return title
		else if (title == "" || title == "") return artist
		else return `${artist} - ${title}`
	}
	function getText(): string {
		const icon = playerIcons[player.desktopEntry] ?? playerIcons[player.identity.toLowerCase()] ?? playerIcons["default"]
		if (!open) return icon
		const description = getMediaDescription(player.trackArtist, player.trackTitle)
		const timeString = `[${formatLength(player.position)}/${formatLength(player.length)}]`
		let result = [icon, description, timeString].filter(v => v != "" && v != null).join(" ")
		if (module.maxLength != null && result.length > module.maxLength) {
			const delta = result.length - module.maxLength
			const shortenedDescription = description.slice(0, -(delta + module.ellipsis.length)) + module.ellipsis
			result = [icon, shortenedDescription, timeString].filter(v => v != "" && v != null).join(" ")
		}
		return result
	}
	text: getText()

	font.italic: player.playbackState == MprisPlaybackState.Paused

	onClicked: {
		if (open) player.togglePlaying()
		else open = true
	}
	onRightClicked: open = false
}