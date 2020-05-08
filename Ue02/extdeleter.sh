#!/bin/bash

ERRMSGINVARGS="Unzulaessige Anzahl an Argumenten. Erwarte\n1: Dateiendung."
ERRMSGNOMATCH="Keine Datei hat die Endung ${1}."

SCRIPTNAME="$(basename ${BASH_SOURCE})"

if [[ "$#" != 1 ]]; then
	>&2 echo -e "${ERRMSGINVARGS}"
	exit 1
fi

# Stelle sicher, dass das Skript ausgefuehrt werden soll
echo -e "\e[1;31mACHTUNG\e[0m: Das Skript loescht alle Dateien, die nicht die vorgegebene Dateiendung haben. Trotzdem fortfahren? [Y/n]"
read -n1 -s ANSWER
if [[ -n "${ANSWER}" && "${ANSWER}" != "Y" && "${ANSWER}" != "y" ]]; then
	>&2 echo "Abbruch aufgrund einer Benutzereingabe."
	exit 2
fi

# Kritischer Teil: Loeschen der Dateien. 
# Finde die zu loeschenden Dateien, aber nie dieses Skript
find . \! \( -name \*.${1} -or -name "${SCRIPTNAME}" -or -name \. \) -delete

exit $?
