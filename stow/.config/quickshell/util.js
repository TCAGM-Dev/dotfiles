function range(n) {
	return [...Array(n).keys()]
}

function smartJoin(arr, sep) {
	return arr.filter(v => v != null && v != "").join(sep)
}