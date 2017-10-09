tell application "OmniFocus" to tell content of document window 1 of default document
	# Set selection to the first sibling task following the current selection.
	# Or the last task preceding, if there are no following sibling tasks.
	set theFirstTree to the first item of the selected trees
	set theLastTree to the last item of the selected trees
	set every selected tree's selected to false
	if the (count of theLastTree's following siblings) > 0 then
		set selected of the first item of theLastTree's following siblings to true
	else if the (count of theFirstTree's preceding siblings) > 0 then
		set selected of the last item of theFirstTree's preceding siblings to true
	end if
end tell
