#!/bin/bash -eux

function testfn()
{
  local fn="${1}.txt"
  echo abc >"$fn"
}

cd /tmp
x=$'\xf0\x9f\xa5\xb4'
testfn "$x"
x="$x$x"
testfn "$x"
x="$x$x"
testfn "$x"
x="$x$x"
testfn "$x"
x="$x$x"
testfn "$x"
x="$x$x"
testfn "$x"
