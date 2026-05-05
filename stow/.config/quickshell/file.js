function read(filePath) { // https://stackoverflow.com/a/7784583
	return new Promise((resolve, reject) => {
		if (process.env.QML_XHR_ALLOW_FILE_READ != 1) return reject("Not allowed to read local files, add the QML_XHR_ALLOW_FILE_READ=1 environment variable")
		const req = new XMLHttpRequest;
		req.open("GET", `file://${filePath}`)
		req.onreadystatechange = function() {
			if (req.readyState == XMLHttpRequest.DONE) {
				if (req.status == 200) {
					resolve(req.response)
				} else {
					reject()
				}
			}
		}
		req.send()
	})
}
