property onHold : " (On Hold)"

tell application "OmniFocus"
	tell content of document window 1 of default document
		set theTaskList to get the value of the selected trees
		tell me to run script (alias ((path to me as text) & "::move-selection.applescript"))

		repeat with theTask in the reverse of theTaskList
			set theProject to theTask's containing project
			set theName to theProject's name

			# Find the "on hold" project name for the "active" project (or vice versa)
			if theName ends with onHold then
				set theOtherName to items 1 through (the (count of theName) - the (count of onHold)) of theName as string
			else
				set theOtherName to theName & onHold
			end if

			# Move task to other project (if it exists)
			set theFolder to theProject's folder
			if exists theFolder's project named theOtherName then
				set theOtherProject to theFolder's project named theOtherName
				if theOtherName ends with onHold then
					move theTask to the beginning of theOtherProject's tasks
					set theTask's flagged to false
					set theTask's defer date to missing value
					set theTask's due date to missing value
				else
					move theTask to the end of theOtherProject's tasks
				end if
			else
				display dialog "Project \"" & theOtherName & "\" does not exist" with title "Toggle Someday" buttons {"Ok"}
			end if
		end repeat
	end tell
end tell
