#!/bin/sh

if test $1; then
    mcedit "$@"
else
    TEMP=`mktemp`
    cat /dev/stdin > $TEMP
    mcedit $TEMP < /dev/tty
fi
exit

