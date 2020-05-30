#!/bin/bash

USAGE="USAGE: $0"

ERR_NUM_PARA=1
ERR_NO_FILES=2
declare -a ERRMSG
ERRMSG[$ERR_NUM_PARA]="Invalid amount of parameters."
ERRMSG[$ERR_NO_FILES]="No files matching 'syslog*' found."

# -------

# parameter check
if [[ $# != 0 ]]; then
	>&2 echo $USAGE
	>&2 echo ${ERRMSG[$ERR_NUM_PARA]}
	exit $ERR_NUM_PARA
fi

files=`ls syslog*`
# check if there are files maching syslog*
if [[ -z "$files" ]]; then
	>&2 echo ${ERRMSG[$ERR_NO_FILES]}
	exit $ERR_NO_FILES
fi

# explain the columns
echo -e "file\t\tmax\tmin"
# go through the files one by one
for file in $files; do
	# extract voltages, sort them numerically
	volts=`cat "$file" | awk '{ print $3 }' | sort -n`
	# extract max and min value (in first and last line after sorting)
	min=`echo "$volts" | head -n1`
	max=`echo "$volts" | tail -n1`
	# print the result
	echo -e "${file}\t${max}\t${min}"
done

exit $?
