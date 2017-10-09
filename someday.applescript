tell application "OmniFocus"
	tell content of document window 1 of default document
		set onHold to " (On Hold)"

		set theTreeList to the selected trees

		# Set selection to the first sibling task following the current selection.
		# Or the last task preceding, if there are no following sibling tasks.
		set theFirstTree to the first item of the selected trees
		set theLastTree to the last item of the selected trees
		if the (count of theLastTree's following siblings) > 0 then
			set selected of the first item of theLastTree's following siblings to true
		else if the (count of theFirstTree's preceding siblings) > 0 then
			set selected of the last item of theFirstTree's preceding siblings to true
		end if

		repeat with theTree in the reverse of theTreeList
			# Deselect task to be moved
			set theTree's selected to false

			set theTask to get the value of theTree
			set theProject to the containing project of theTask
			set theName to the name of theProject

			# Find the "on hold" project name for the "active" project (or vice versa)
			if theName ends with onHold then
				set theOtherName to items 1 through (the (count of theName) - the (count of onHold)) of theName as string
			else
				set theOtherName to theName & onHold
			end if

			# Move task to other project (if it exists)
			set theFolder to the folder of theProject
			if exists theFolder's project named theOtherName then
				set theOtherProject to theFolder's project named theOtherName
				if theOtherName ends with onHold then
					move theTask to the beginning of the tasks of theOtherProject
					set theTask's flagged to false
					set theTask's defer date to missing value
					set theTask's due date to missing value
				else
					move theTask to the end of the tasks of theOtherProject
				end if
			else
				display dialog "Project \"" & theOtherName & "\" does not exist" with title "Toggle Someday" buttons {"Ok"}
			end if
		end repeat
	end tell
end tell
