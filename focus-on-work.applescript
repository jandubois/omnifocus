tell application "OmniFocus"
	tell the default document
		set theFolderList to folders whose name is "Work"
		tell the front document window to set the focus to theFolderList
	end tell
end tell
