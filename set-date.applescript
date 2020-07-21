#!/usr/bin/osascript

on run theArgs
	set theDateType to item 1 of theArgs
	set theWeekday to item 2 of theArgs

	set today to the current date
	if theWeekday is in {"c", "l", "h", "r"} then
		# clear, flag, hold, radar
		set theNewDate to the missing value
	else if theWeekday is "t" then
		set theNewDate to today + 1 * days
	else if theWeekday is "y" then
		set theNewDate to today
	else
		# theWeekday is "1".."7" for Monday to Sunday; map to AppleScript weekday value
		set theDesiredWeekday to (8 + theWeekday as number) mod 7
		set addDays to (7 - ((weekday of today as number) - theDesiredWeekday)) mod 7
		if addDays = 0 then set addDays to 7
		set theNewDate to today + addDays * days
	end if

	tell application "OmniFocus"
		set whenTag to item 1 of (tags of default document whose name is "When")
		set onHoldTag to item 1 of (tags of whenTag whose name is "On Hold")
		set onRadarTag to item 1 of (tags of whenTag whose name is "On Radar")
	end tell

	tell application "OmniFocus" to tell the content of document window 1 of the default document
		set theTaskList to get the value of the selected trees
		if theDateType is "due" then
			tell me to run script (alias ((path to me as text) & "::move-selection.applescript"))
		end if
		repeat with theTask in theTaskList
			# Remove "On Hold" and "On Radar" tags from task
			if (count of (theTask's tags whose name is "On Hold")) > 0 then
				remove onHoldTag from theTask's tags
			end if
			if (count of (theTask's tags whose name is "On Radar")) > 0 then
				remove onRadarTag from theTask's tags
			end if

			# Set time of day for defer/due tasks, depending on work/not-work, and on weekday
			if theNewDate is not the missing value then
				# Find the top-level folder of the task
				set theContainer to the folder of theTask's containing project
				repeat while the class of theContainer's container is folder
					set theContainer to theContainer's container
				end repeat

				if theDateType is "due" then
					if theContainer's name is "Work" then
						set time of theNewDate to 17 * hours
					else
						set time of theNewDate to 23 * hours
					end if

					# Saturday and Sunday tasks always become due at the end of the day
					# XXX How can we detect holidays and treat them like weekends?
					if the weekday of theNewDate is in {Saturday, Sunday} then
						set time of theNewDate to 23 * hours
					end if
				else
					if theContainer's name is "Work" then
						set time of theNewDate to 6 * hours
					else
						set time of theNewDate to 18 * hours
					end if

					# Saturday and Sunday tasks always become available in the morning
					if the weekday of theNewDate is in {Saturday, Sunday} then
						set time of theNewDate to 6 * hours
					end if
				end if
			end if

			# Update due or defer date to new (or missing) value
			if theDateType is "due" then
				set theTask's due date to theNewDate
			else
				set theTask's defer date to theNewDate
			end if

			# Flag, On Hold, and On Radar will clear *both* due and defer dates
			if theWeekday is in {"l", "h", "r"} then
				set theTask's due date to the missing value
				set theTask's defer date to the missing value
			end if

			if theWeekday is "l" then
				# On Hold and On Radar tags have already been removed
				set theTask's flagged to true
			end if

			if theWeekday is "h" then
				add onHoldTag to theTask's tags
				set theTask's flagged to false
			end if
			if theWeekday is "r" then
				add onRadarTag to theTask's tags
				set theTask's flagged to false
			end if

		end repeat
	end tell
end run
