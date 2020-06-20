#!/bin/bash

# sepcify output file
file="pwned_emails.csv"

# detailed explanation below
curl -sk https://www.uni-math.gwdg.de/staff/v2/mitarbeiter.html | \
	grep "email\">" | \
	sed 's/^[[:space:]]*//' | \
	sed 's/<[^>]*href[^>]*>//g' | \
	sed 's/<[b/t][^>]*>//g' | \
	sed 's/<span\ class=\"email\">/, /' | \
	grep "@" | \
	sort | \
	uniq | \
	awk -F", " '{ \
	printf "%s;", $NF
	if (NF == 4)
		printf "%s %s;%s\n", $3, $2, $1
	else
		printf "%s;%s\n", $2, $1
	}' > $file

# curl -sk https://www.uni-math.gwdg.de/staff/v2/mitarbeiter.html | \	get raw data
# 	grep "email\">" | \						search for occurance of 'email">' as to not match "by appointment (via email)"
# 	sed 's/^[[:space:]]*//' | \					remove leading space
# 	sed 's/<[^>]*href[^>]*>//g' | \					remove hyperlinks
# 	sed 's/<[b/t][^>]*>//g' | \					remove <tr>, <br /> and all closing html tags
# 	sed 's/<span\ class=\"email\">/, /' | \				replace the email tag with ", " to keep format consistent (see awk below)
# 	grep "@" | \							exclude entries without email addresses
# 	sort | \							sort the entries to be able to exclude doubles
# 	uniq | \							and exclude the doubles
# 	awk -F", " '{ \							awk with field speparator ", "
# 	if (NF == 4)							if the person has a title (NF = # of fields) ...
# 		printf "%s %s;%s;", $3, $2, $1				... prepend it to the first name to be in the right spot for the mail later
# 	else								else ...
# 		printf "%s;%s;", $2, $1					... print the names in the format first name first, last name last
# 	printf "%s\n", $NF						print the email address ($NF is last field, so $3 or $4)
# 	}' > $file							write all that to the file specified in the head of this script

exit $?
