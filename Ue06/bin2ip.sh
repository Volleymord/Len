#!/bin/bash

# check for correct args/format
if [[ $# != 1 ]]; then
	>&2 echo "Invalid amount of arguments."
	exit 1
elif [[ $(echo $1 | grep -o "\." | wc -l) != 3 ]]; then
	>&2 echo "Invalid input: $1. Expecting [01]{8}.[01]{8}.[01]{8}.[01]{8}"
	exit 2

# check for correct numbers
elif [[ -n "$(echo $1 | sed 's/[01]\{8\}\.\?//g')" ]]; then
	>&2 echo "Invalid input: $1. Expecting [01]{8}.[01]{8}.[01]{8}.[01]{8}"
	exit 2
fi

# -------

# calculate decimal representation of binary ip address
out=""
cache="0"
for field in $(echo $1 | awk -F'.' '{print $1,$2,$3,$4}'); do
	res="128"
	for i in {1..8}; do
		bit=$(echo $field | cut -c "${i}")
		if [[ "$bit" -eq 1 ]]; then
			cache=$((cache+res))
		fi
		res=$((res/2))
	done
	out="${out}${cache}."
	cache="0"
done
# output "out" without the last dot
# bash >= 4.2 required, else: spaces before and after :, or use "rev" and "cut -c2-"
echo "${out::-1}"

exit $?
