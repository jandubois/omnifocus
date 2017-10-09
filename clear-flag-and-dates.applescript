tell application "OmniFocus" to tell document window 1 of default document
	set theTaskList to get value of the content's selected trees
	if perspective name is "Due" then
		tell me to run script (alias ((path to me as text) & "::move-selection.applescript"))
	end if
	repeat with theTask in theTaskList
		set theTask's flagged to false
		set theTask's defer date to missing value
		set theTask's due date to missing value
	end repeat
end tell
