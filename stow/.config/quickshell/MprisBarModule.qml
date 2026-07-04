import Quickshell.Services.Mpris
import Quickshell.Hyprland
import QtQuick
import "util.js" as Util

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
		"kew":  "",
		"ratune": "󱝉",
		"supersonic": "󱝉",
		"default": "",
	}

	function formatLength(length: real): string {
		const minutes = Math.floor(length / 60)
		const seconds = Math.floor(length % 60)
		return `${minutes}:${seconds < 10 ? `0${seconds}` : seconds}`
	}

	readonly property list<MprisPlayer> players: Mpris.players.values.filter(player => !module.ignored.includes(player.desktopEntry))
	readonly property var player: players[0] // TODO: Find way to improve this

	visible: player != null

	Timer {
		id: lengthRefresher

		running: module.player?.playbackState == MprisPlaybackState.Playing && !(module.monitor.activeWorkspace?.hasFullscreen ?? false)

		interval: 1000
		repeat: true

		onTriggered: module.player.positionChanged()
	}

	Timer {
		id: idleCloser

		running: module.player != null && module.player.playbackState != MprisPlaybackState.Playing

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
		if (player == null) return ""
		const icon = playerIcons[player.desktopEntry] ?? playerIcons[player.identity.toLowerCase()] ?? playerIcons["default"]
		if (!open) return icon
		const description = getMediaDescription(player.trackArtist, player.trackTitle)
		const timeString = `[${formatLength(player.position)}/${formatLength(player.length)}]`
		let result = Util.smartJoin([icon, description, timeString], " ")
		if (module.maxLength != null && result.length > module.maxLength) {
			const delta = result.length - module.maxLength
			const shortenedDescription = description.slice(0, -(delta + module.ellipsis.length)).trim() + module.ellipsis
			result = Util.smartJoin([icon, description, timeString], " ")
		}
		return result
	}
	text: getText()

	font.italic: player == null ? false : player.playbackState == MprisPlaybackState.Paused

	onClicked: {
		if (open) player.togglePlaying()
		else open = true
	}
	onRightClicked: open = false
}