BarModule {
	property bool showDate: false
	
	text: showDate ? Clock.currentDate : Clock.currentTime

	onClicked: () => {
		showDate = !showDate
		if (showDate) Clock.update()
	}
}
