#!/bin/sh

dr=$(pwd)
[ -n "$1" ] && dr=$1
#LIST /$dr
if ls -1 /$dr >/dev/null 2>&1 ; then
    lsopts="-lan"
    if ls -Q /$dr >/dev/null 2>/dev/null; then
	lsopts=$lsopts"Q"
    fi
    ls $lsopts /$dr 2>/dev/null | grep '^[^cbt]' | (
	 while read p l u g s m d y n; do
	 echo "P$p $u.$g
S$s
d$m $d $y
:${n}
"
	done
    )
    ls $lsopts /$dr 2>/dev/null | grep '^[cb]' | (
	while read p l u g a i m d y n; do
	    echo "P$p $u.$g
E$a$i
d$m $d $y
:${n}
"
	done
    )
    echo '### 200'
else
    echo '### 500'
fi
