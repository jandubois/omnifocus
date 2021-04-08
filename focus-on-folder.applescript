#!/usr/bin/osascript

on run theArgs
	if (count of theArgs) is 0 then
		set theFolderName to (system attribute "KMVAR_FolderName")
		if theFolderName is "" then
			set theFolderName to "!Work"
		end if
	else
		set theFolderName to item 1 of theArgs
	end if
	tell application "OmniFocus" to tell the default document
		if theFolderName starts with "!" then
			set theFolderList to folders whose name is not (characters 2 thru -1 of theFolderName as string)
		else
			set theFolderList to folders whose name is theFolderName
		end if
		tell the front document window to set the focus to theFolderList
	end tell
end run
