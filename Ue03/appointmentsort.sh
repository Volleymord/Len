#!/bin/bash

# upfront: This might be acchievable way easier than I did it here. Please let me know if you found a solution you think is neat.

OUTPUT_FILE="${HOME}/Documents/Len/Uebungen/Ue03/jugm_appointments.txt"

# curl -s "https://www.jugm.de/" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed '/^[[:space:]]*$/d' | grep -A 3 "..\...\.2020"

# if crossed out dates should be neglected
results=`curl -s "https://www.jugm.de/" | \
	grep -v "<s>" | \
	sed 's/^[[:space:]]*//' | \
	sed '/>[[:space:]]*$/!{N;s/\n//;}' | \
	sed 's///' | \
	grep -A 3 "..\...\.2020" | \
	sed 's/<[^>]*>//g' | \
	sed '/^[[:space:]]*$/d' | \
	sed 's/&uuml;/ue/g' `

# curl -s "https://www.jugm.de/" | \ 		get the html code
# 	grep -v "<s>" | \			remove the crossed out results so they don't get matched
# 	sed 's/^[[:space:]]*//' | \		remove the leading spaces
# 	sed '/>[[:space:]]*$/!{N;s/\n//;}' | \	remove the newlines if the line does not end on a ">". 
# 						This is needed, as the last talk is by 3 people and they are not all in one line. 
#						This introduces a special character  (typed by pressing Ctrl+v Ctrl+m without letting Ctrl go) though.
# 	sed 's///' | \			remove the special character
# 	grep -A 3 "..\...\.2020" | \		the actual filter: Search for a date and print the following 3 lines from there on. 
#						This delimits the different results by \n--\n.
# 	sed 's/<[^>]*>//g' | \			remove all the html environments <p> and co
# 	sed '/^[[:space:]]*$/d' | \		remove all empty lines
# 	sed 's/&uuml;/ue/g'			change the html code for the Umlaut ue to ue

# including crossed out dates, this does not work properly because of inconsistent formatting of the website. This is intended by the task though. Comment out the following to still get the working result from the code above.
results=`curl -s "https://www.jugm.de/" | \
	sed 's/^[[:space:]]*//' | \
	sed '/>[[:space:]]*$/!{N;s/\n//;}' | \
	sed 's///' | \
	grep -A 3 "..\...\.2020" | \
	sed 's/<[^>]*>//g' | \
	sed '/^[[:space:]]*$/d' | \
	sed 's/&uuml;/ue/g' `


# now print the data in the desired format
echo "${results}" | \
	sed 's/^--$//' | \
	sed '/.*/{N;s/\n/;/;}' | \
	sed 's/\r//' | \
	sed '/.*/{N;s/\n/;/;}' | \
	sed 's/\([^;]\)$/\1;/' | \
	awk -F";" '{ printf "%s;%s;%s\n", $1,$3,$2 }' \
	> ${OUTPUT_FILE}

# echo "${results}" | \						echo the results from earlier
# 	sed 's/^--$//' | \					remove the delimiter from the different results from grep
# 	sed '/.*/{N;s/\n/;/;}' | \				substitute the newline with a semicolon (this applies on every other line)
# 	sed 's/\r//' | \					remove the carriage return
# 	sed '/.*/{N;s/\n/;/;}' | \				substitute the newline with a semincolon on the remaining lines
# 	sed 's/\([^;]\)$/\1;/' | \				add a semicolon to the last entry
# 	awk -F";" '{ printf "%s;%s;%s\n", $1,$3,$2 }'		reorganize the entries

exit $?
