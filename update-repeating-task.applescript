#!/usr/bin/osascript

# defer - create non-repeating duplicate one day later, and advance repeating task to next instance
# final - make task non-repeating and complete
# skip - advance repeating task to next instance, skipping the current one

on run theArgs
	set theAction to item 1 of theArgs
	if theAction is not in {"d", "f", "s"} then
		# XXX Dialog will not be displayed when run via Karabiner
		display dialog "Action must be one of (d)efer, (f)inal, or (s)kip" with title "Update repeating task" buttons {"Ok"}
		error number -128
	end if

	tell application "OmniFocus" to tell the content of the first document window of the default document
		set theSelectedTrees to the selected trees
		repeat with theTree in theSelectedTrees
			set theTask to get the value of theTree
			if theTask's repetition rule is the missing value then
				display dialog theTask's name with title "Not a repeating task" buttons {"Ok"}
				error number -128
			end if
			set selected of theTree to false
			if theAction is "d" then
				set theDupe to duplicate theTask to after theTask with properties {repetition rule:missing value}
				set theLeaves to (the leaves whose id is theDupe's id)
				set selected of the first item of theLeaves to true
				if theDupe's defer date is not the missing value then
					set theDupe's defer date to (theDupe's defer date) + 1 * days
				end if
				if theDupe's due date is not the missing value then
					set theDupe's due date to (theDupe's due date) + 1 * days
				end if
			end if
			if theAction is "f" then
				set theTask's repetition rule to the missing value
			end if
			mark complete theTask
			if theAction is in {"d", "s"} then
				delete (get the value of theTree)
			end if
		end repeat
	end tell
end run
