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
if [[ -z "$files" ]]; then
	>&2 echo ${ERRMSG[$ERR_NO_FILES]}
	exit $ERR_NO_FILES
fi

echo -e "file\t\tmax\tmin"
for file in $files; do
	volts=`cat "$file" | awk '{ print $3 }' | sort -n`
	min=`echo "$volts" | head -n1`
	max=`echo "$volts" | tail -n1`
	echo -e "${file}\t${max}\t${min}"
done

exit $?
