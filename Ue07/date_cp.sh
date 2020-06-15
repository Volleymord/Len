#!/bin/bash

ERRMSGNOFILE="Die angegebene Datei existiert nicht. Das Skript erwartet die Ausfuehrung von SKRIPTNAME DATEINAME."
DIR="${HOME}/documente/"

# assuming errorfunc.sh is in the same directory as this script. If not, supply full path.
. errorfunc.sh

# Ueberpruefe, ob Datei existiert. Wenn nicht, werfe einen Fehler und breche ab.
if [[ ! -f "$1" ]]; then
	>&2 echo "${ERRMSGNOFILE}"
	errorfunction 1 date_cp.sh:ERRNOFILE EXIT 
fi

# Erzeuge den Ordner, falls er nicht existiert
[[ ! -d "${DIR}" ]] && mkdir -v "${DIR}"
# extrahiere den Namen der Datei, um einen Aufruf aus einem anderen Pfad als dem Dateipfad zu ermoeglichen
FILENAME=`basename "$1"`
DATUM=`date +%Y%m%d`
cp "$1" "${DIR}${DATUM}${FILENAME}"

exit $?
