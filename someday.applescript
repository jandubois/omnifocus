tell application "OmniFocus"
	tell content of document window 1 of default document
		set onHold to " (On Hold)"
		set theTaskList to get the value of the selected trees
		repeat with theTask in the reverse of theTaskList
			set theProject to the containing project of theTask
			set theName to the name of theProject
			if theName ends with onHold then
				set theOtherName to items 1 through (the (count of theName) - the (count of onHold)) of theName as string
			else
				set theOtherName to theName & onHold
			end if
			set theFolder to the folder of theProject
			if exists theFolder's project named theOtherName then
				set theOtherProject to theFolder's project named theOtherName
				if theOtherName ends with onHold then
					move theTask to the beginning of the tasks of theOtherProject
				else
					move theTask to the end of the tasks of theOtherProject
				end if
			else
				display dialog "Project \"" & theOtherName & "\" does not exist" with title "Toggle Someday" buttons {"Ok"}
			end if
		end repeat
	end tell
end tell
