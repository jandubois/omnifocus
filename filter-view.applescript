#!/usr/bin/osascript

# Valid arguments are "next", "available", "incomplete", and "complete".
# "incomplete" meaning "remaining".
on run theArgs
	if (the count of theArgs) is 0 then
		set theDesiredState to "available"
	else
		set theDesiredState to item 1 of theArgs
	end if
	tell application "OmniFocus" to tell the content of document window 1 of the default document
		set the selected task state filter identifier to theDesiredState
	end tell
end run
