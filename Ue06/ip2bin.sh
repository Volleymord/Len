#!/bin/bash

# check for correct args/format
if [[ $# != 1 ]]; then
	>&2 echo "Invalid amount of arguments."
	exit 1
elif [[ $(echo $1 | grep -o "\." | wc -l) != 3 ]]; then
	>&2 echo "Invalid input: $1. Expecting xxx.xxx.xxx.xxx"
	exit 2
fi

# check for correct numbers
for num in $(echo $1 | awk -F'.' '{ print $1,$2,$3,$4 }'); do
	if [[ "$num" -gt 255 ]]; then
		>&2 echo "Invalid value in ip address: $num"
		exit 3
	fi
done

# -------

# calculate binary representation of ip address
out=""
for field in $(echo $1 | awk -F'.' '{print $1,$2,$3,$4}'); do
	for mod in {128,64,32,16,8,4,2,1}; do
		res=$(echo "${field}%${mod}" | bc)
		if [[ $res -eq $field ]]; then
			out="${out}0"
		else
			out="${out}1"
			field=$((field-mod))
		fi
	done
	out="${out}."
done
# output "out" without the last dot
# bash >= 4.2 required, else: spaces before and after :, or use "rev" and "cut -c2-"
echo "${out::-1}"

exit $?
