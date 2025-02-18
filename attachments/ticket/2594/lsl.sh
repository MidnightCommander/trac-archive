#!/bin/bash

LS=(
'drwxrwxrwt  5 root root 4096 Aug 18 09:19 .'
'drwxr-xr-x 17 root root 4096 Aug 17 10:49 ..'
'-rw-r--r--  1 536  536  4001599488 Aug 01 15:52
 KNOPPIX_V6.7.0DVD-2011-08-01-EN.iso'
'-rw-r--r--  1 536  536  70 Aug 01 20:06
 KNOPPIX_V6.7.0DVD-2011-08-01-EN.iso.md5'
'-rw-r--r--  1 536  536  385468 Aug 02 19:38 packages-dvd.txt'
)

echo "Output from some ls -l; fields are NOT aligned"
for (( L=0 ; L<6 ; L++ ))
	do
		LINE=${LS[L]}
		echo $LINE
	done

echo "Line parsed into an array; element 8 is file name"
for (( L=0 ; L<6 ; L++ ))
	do
		LINE=( ${LS[L]} )
		LINEARRAY=( $LINE )
		FILENAME=${LINE[8]} #element numbers start at 0
		echo $FILENAME
	done
echo "Note that there is now NO white space."
