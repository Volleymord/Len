#!/bin/bash

# used basefile:
# -- BEGIN basefile
# 001;Frau;Marie;Curie
# 002;Herr;Erwin;Schroedinger
# 007;Herr;James;Bond
# -- END basefile

NARGS=1
USAGE="$0 csv_file"

ERRMSGINVARGS="Invalid number of arguments. Expecting 1. \nUSAGE: ${USAGE}"
ERRMSGNOFILE="File $1 not found. \nUSAGE: ${USAGE}"
ERRMSGINVFILE="File $1 is invalid. CSV file must use the field seperator ';'."

# parameter check
if [[ $# > ${NARGS} || $# == 0 ]]; then
	>&2 echo -e "${ERRMSGINVARGS}"
	exit 1
elif [[ ! -f "$1" ]]; then
	>&2 echo -e "${ERRMSGNOFILE}"
	exit 2
fi

# check if file is formatted correctly
filename=`basename -- "${1}"`
extension=${filename##*.}
if [[ "${extension}" != "csv" || -z `grep ';' "$1"` ]]; then
	>&2 echo -e "${ERRMSGINVFILE}"
	exit 3
fi

# write the repeating text into variables
HEAD="Sehr geehrte"
BODY=",\nden Beitrag fuer Ihre Mitgliedschaft\nziehen wir in Kuerze ein. Ihre Mitgliedsnummer\nist: "
FOOT="\nmit freundlichen Gruessen\nDer Vorstand\n"

cat "$1" | \
	awk -F ";" \
	-v HEAD="$HEAD" -v BODY="$BODY" -v FOOT="$FOOT" \
	'{ if ($2 ~ /.*r$/) \
		printf "%sr %s %s %s%s%s%s\n", HEAD,$2,$3,$4,BODY,$1,FOOT ;\
	else
		printf "%s %s %s %s%s%s%s\n", HEAD,$2,$3,$4,BODY,$1,FOOT ;\
	}'

# cat "$1" | \									Output the file
# 	awk -F ";" \								field separator ;
# 	-v HEAD="$HEAD" -v BODY="$BODY" -v FOOT="$FOOT" \			take the variables from the shell
# 	'{ if ($2 ~ /.*r$/) \							if the form of address matches '.*r$' so ends with a r (Herr, Mr)
# 		printf "%sr %s %s %s%s%s%s\n", HEAD,$2,$3,$4,BODY,$1,FOOT ;\	append a r to 'Sehr geehrte'
# 	else									else: Female reciever
# 		printf "%s %s %s %s%s%s%s\n", HEAD,$2,$3,$4,BODY,$1,FOOT ;\	no appendage needed
# 	}'

exit $?
