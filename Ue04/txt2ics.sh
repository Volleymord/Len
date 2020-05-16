#!/bin/bash

# Used source of the events:
# -- BEGIN events
# Do 21.12.
# 10.00 Agla I

# 12.00 Algebra

# 14.00 Oberseminar
# Fr 22.12.
# 10.00 Diff I

# 12.00 Numerik
# -- END events

OUTPUTFILE="custom_calender.ics"

USAGE="$0 eventfile"

ERRMSGINVARGS="Invalid amount of arguments. Expecting 1.\nUSAGE: ${USAGE}"
ERRMSGINVFMT="Invalid format of file $1."

# Write recurring strings in variables
HEAD="BEGIN:VCALENDAR\nPRODID:-//K Desktop Environment//NONSGML KOrganizer 3.5.3//EN\nVERSION:2.0"
BEGIN="BEGIN:VEVENT\nDTSTAMP:`date +%Y%m%dT%H%M%SZ`\nORGANIZER;CN=Stefan Koospal:MAILTO:\nCREATED:`date +%Y%m%dT%H%M00Z`"
SEQ="SEQUENCE:0\nLAST-MODIFIED:`date +%Y%m%dT%H%M00Z`"
CLASS="CLASS:PUBLIC\nPRIORITY:5"
END="TRANSP:OPAQUE\nEND:VEVENT"
FOOT="END:VCALENDAR"

# Write function to change between outputting to stdout or writing to file easily
# Mind that when using the first option the last action in this script i.e. the line ending conversion
# is not needed. Comment out these lines if using the first option.
WRITE () {
	# echo -e $*
	echo -e $* >> ${OUTPUTFILE}
}

# ----------

# Clear outputfile
if [[ -f ${OUTPUTFILE} ]]; then
	rm -i "${OUTPUTFILE}"
fi

# Parameter check
if [[ $# != 1 ]]; then
	>&2 echo -e "${ERRMSGINVARGS}"
	exit 1
fi

# Write reformatted file into variable TEXT
# This makes each line with the date take the format 2020MMDD and removes the dot in the time as well
# as removing empty lines
TEXT=`cat $1 | \
	sed '/^$/d' | \
	sed 's/^[MDFSTW][oiuehra]\ \([0-3][0-9]\)\.\([01][0-9]\)\.$/2020\2\1/' | \
	sed 's/^\([0-2][0-9]\)\./\1/' `

# Create a buffer variable for the date
DATEBUFFER=""

# Write the head of the ics file
WRITE "${HEAD}"

# Process TEXT line by line
echo "${TEXT}" | while read line; do
	# Update the DATEBUFFER if a date is encountered
	if [[ $line =~ ^2020[01][0-9][0-3][0-9]$ ]]; then
		DATEBUFFER=$line

	# In the lines with the events
	elif [[ $line =~ ^[012][0-9][0-5][0-9][[:space:]]+ ]]; then
		# Extract summary and time of the event
		SUMMARY=`echo "$line" | awk '{ for (i = 2; i < NF; i++) printf $i " "; print $NF}'`
		TIME=`echo "$line" | awk '{ print $1 }'`
		# Write the ics FILE
		WRITE "${BEGIN}"
		# Create a unique identifier
		WRITE "UID:KOrganizer-${DATEBUFFER}.${RANDOM}"
		WRITE "${SEQ}"
		WRITE "SUMMARY:${SUMMARY}"
		WRITE "${CLASS}"
		WRITE "DTSTART:${DATEBUFFER}T${TIME}00Z"
		# The end time of the event is assumed to be 2 hours after the start for every event
		ENDTIME=$((TIME + 200))
		WRITE "DTEND:${DATEBUFFER}T${ENDTIME}00Z"
		# Write the end block of the single event
		WRITE "${END}"
	else
		# In this case the format is messed up somehow
		>&2 echo -e "When parsing '${line}':\n${ERRMSGINVFMT}"
		exit 2
	fi
done
# Append the footer of the ics file
WRITE "${FOOT}"

# References:
# Regex matching in if: https://stackoverflow.com/a/18710850
# Print everything but the first field in awk: https://stackoverflow.com/a/7918051

# As https://icalendar.org/validator.html expects CRLF as line endings, change the \n to \r\n:
# If you see a linebreak in the line below this one: There is a character (printed as ^M in vim). 
# It can be typed by pressing Ctrl+v and then Ctrl+m without letting Ctrl go.
OUT=`cat "${OUTPUTFILE}" | sed "s/$//" `
echo "${OUT}" > ${OUTPUTFILE}

exit $?	
