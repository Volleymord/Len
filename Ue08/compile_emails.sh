#!/bin/bash

# define files
base="email_base.txt"
targets="pwned_emails.csv"

# test for invalid formatting of base file
if [[ -z "`grep "#Vorname#" "$base"`" ]] || [[ -z "`grep "#Nachname#" "$base"`" ]] || [[ -z "`grep "#Email#" "$base"`" ]]; then
	>&2 echo "Invalid format of base file $base."
	exit 1
# test for invalid formatting of targets file
# this ensures there are exactly 3 fields delimited by ";" and the character "@" is in the first field
elif [[ -n "`cat "$targets" | sed 's/^[^;]*@[^;]*;[^;]*;[^;]*$//' | tr -d '[:space:]'`" ]]; then
	>&2 echo "Invalid format of target tile $targets."
	exit 2
fi

# test string if you want to test this code but not blow up your terminal with MANY mails
test_string=`head -n3 "$targets"`

# go through targets file line by line
while read line; do
	# extract information from the fields
	first_name=`echo "$line" | awk -F";" '{print $2}'`
	last_name="`echo "$line" | awk -F";" '{print $3}'`"
	email_address="`echo "$line" | awk -F";" '{print $1}'`"

	# output the draft message, replacing the placeholders
	cat "$base" | \
		sed "s/#Vorname#/${first_name}/g" | \
		sed "s/#Nachname#/${last_name}/g" | \
		sed "s/#Email#/${email_address}/g"

	# visually separate the different mails
	echo "###################"
done < "$targets"
# just for testing:
# done <<< "$test_string"

exit $?
