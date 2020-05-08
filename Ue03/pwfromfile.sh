#!/bin/bash

# This script was tested with
# -- BEGIN base_file
# Institution;Name;Vorname;Strasse;PLZ;Ort
# MPIDS;Golestanian;Ramin;Am Fassberg 17;37077;Goettingen
# MI;Koospal;Stefan;Bunsenstrasse 3-5;37073;Goettingen
# MI6;Bond;James;nondisclosed;12345;London
# -- END base_file

USAGE="USAGE: $0 base_file"
ERRMSGINVARGS="Invalid amount of arguments.\n${USAGE}"
ERRMSGNOFILE="File $1 not found.\n${USAGE}"

OUTPUT_FILE="${HOME}/Documents/Len/Uebungen/Ue03/pw_output.txt"
# clear file, start fresh
if [[ -f "$OUTPUT_FILE" ]]; then
	echo "Clearing old output file at ${OUTPUT_FILE}."
	rm -f "$OUTPUT_FILE"
fi
touch "$OUTPUT_FILE"


# parameter check
if [[ $# != 1 ]]; then
	>&2 echo "${ERRMSGINVARGS}"
	exit 1
elif [[ ! -f $1 ]]; then
	>&2 echo "${ERRMSGNOFILE}"
	exit 2
fi

while read line; do
	# generate usernames
	name=`echo "$line" | awk -F";" '{ printf "%s;%s", $2,$3 }'`
	name_natural=`echo "$line" | awk -F";" '{ print $3,$2 }'`
	username=`echo "${name_natural}" | tr '[:upper:]' '[:lower:]' | sed 's/\ //g' | cut -c-8`
	# echo "username: $username"
	
	# generate passwords: first and last character from everything but the name -> 4 characters + random number
	rest=`echo "${line}" | awk -F";" '{ printf "%s\n%s\n%s\n", $1,$4,$5,$6 }' | sed 's/\ //g'`
	pw1=`echo "${rest}" | cut -c1 | tr -d '\n'`
	pw2=`echo "${rest: -1}" | tr -d '\n'`

	pw="${pw1}${pw2}${RANDOM}"
	# echo "pw: $pw"

	# encrypt password via md5sum
	encr_pw=`echo "$pw" | md5sum | awk '{ print $1 }'`
	
	# append to output file
	echo "${username};${name};${pw};${encr_pw}" >> ${OUTPUT_FILE}

done < "$1"

exit $?
