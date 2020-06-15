#!/bin/bash

errorfunction () {
	# define the log file. If it does not exist, change that.
	LOGFILE=/tmp/error.log
	[[ ! -f $LOGFILE ]] && touch $LOGFILE

	# descriptive variable names
	LVL=$1
	TXT=$2
	ACTION=$3

	USAGE="USAGE: errorfunction error_level(0-255) error_text [EXIT/CONT]"

	# parameter checks, exit with code not in {0..255} if it fails
	if [[ $# != 3 ]]; then
		>&2 echo -e "errorfunction: Invalid amount of parameters: $#.\n${USAGE}"
		exit -1
	elif [[ $LVL -lt 0 || $LVL -gt 255 ]]; then
		>&2 echo -e "errorfunction: Invalid errorlevel '$LVL'.\n${USAGE}"
		exit -2
	elif [[ $ACTION != "CONT" && $ACTION != "EXIT" ]]; then
		>&2 echo -e "errorfunction: Invalid action '$ACTION'.\n${USAGE}"
		exit -3
	fi

	# create time stamp, append to the logfile
	STAMP=`date --iso-8601='ns'`
	echo "${STAMP} ${ACTION} ${LVL} ${TXT}" >> $LOGFILE

	# exit/return depending on action
	if [[ $ACTION == "EXIT" ]]; then
		exit ${LVL}
	else
		return ${LVL}
	fi
}

# test function not used if the last line in this script is commented out
test_it () {
	# this wont work
	# errorfunction -1 TEXT EXIT
	# errorfunction 2 TEXT CONTINUE

	# this should work
	errorfunction 241 cont_txt CONT
	errorfunction 240 exit_txt EXIT

	exit $?
}

# uncomment to test the errorfunction
# test_it

# IMPORTANT: no exit here. That would mess up the importing of the function into other scripts.
