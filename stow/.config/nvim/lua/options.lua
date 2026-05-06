return {
	number = true, -- Show line numbers in a column.
	relativenumber = false,

	tabstop = 4,
	shiftwidth = 4,
	wrap = false,

	termguicolors = true,

	ignorecase = true, -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	smartcase = true, -- ^

	cursorline = true, -- Highlight the line where the cursor is on.
	scrolloff = 10, -- Keep this many screen lines above/below the cursor.
	list = true, -- Show <tab> and trailing spaces.

	confirm = true, -- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`), instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
}