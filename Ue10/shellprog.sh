#!/bin/bash

# iterate through all programs
for prog in awk sed grep; do
	echo "${prog^^}=`which "${prog}"`"
done

exit $?
