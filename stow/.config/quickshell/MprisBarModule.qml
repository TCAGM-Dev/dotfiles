import Quickshell.Services.Mpris
import Quickshell.Hyprland
import QtQuick

BarModule {
	id: module

	required property HyprlandMonitor monitor

	property list<string> ignored: []
	property var playericons: {
		"spotify": "",
		"firefox": "󰈹",
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

	text: `${playericons[player.desktopEntry] ?? ""} ${player.trackArtist == "" ? "" : `${player.trackArtist} - `}${player.trackTitle} [${formatLength(player.position)}/${formatLength(player.length)}]`
	font.italic: player.playbackState == MprisPlaybackState.Paused

	onClicked: player.togglePlaying()
}
