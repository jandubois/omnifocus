tell application "OmniFocus"
	tell content of document window 1 of default document
		set theTaskList to get the value of the selected trees
		repeat with theTask in the reverse of theTaskList
			set theProject to the containing project of theTask
			move theTask to the beginning of the tasks of theProject
		end repeat
	end tell
end tell
