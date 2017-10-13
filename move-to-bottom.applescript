tell application "OmniFocus"
	tell content of document window 1 of default document
		set theTaskList to get the value of the selected trees
		tell me to run script (alias ((path to me as text) & "::move-selection.applescript"))
		repeat with theTask in theTaskList
			set theProject to the containing project of theTask
			move theTask to the end of the tasks of theProject
		end repeat
	end tell
end tell
