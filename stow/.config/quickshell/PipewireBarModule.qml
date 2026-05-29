import Quickshell.Services.Pipewire

BarModule {
	id: module

	readonly property PwNode sink: Pipewire.defaultAudioSink
	readonly property PwNodeAudio audio: sink.audio

	PwObjectTracker {objects: [module.sink]}

	visible: sink != null && audio != null

	readonly property real volume: audio.volume
	function getIcon(icon) {
		if (Array.isArray(icon)) return icon[Math.round(volume * (icon.length - 1))]
		return icon
	}
	readonly property string deviceIcon: getIcon(["", "", ""]) // TODO: Add different icons for device types if it becomes possible

	onWheel: (e) => {
		audio.volume = Math.min(Math.max(volume + e.angleDelta.y / 12000, 0), 1)
	}

	text: `${Math.round(volume * 100)}% ${deviceIcon}`
}