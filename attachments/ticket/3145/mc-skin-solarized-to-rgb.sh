#!/bin/sh

sed -e '/\[skin\]/a\
    truecolors = true' \
    -e 's/white/#fdf6e3/g' \
    -e 's/lightgray/#eee8d5/g' \
    -e 's/brightcyan/#93a1a1/g' \
    -e 's/cyan/#2aa198/g' \
    -e 's/brightmagenta/#6c71c4/g' \
    -e 's/magenta/#d33682/g' \
    -e 's/brightblue/#839496/g' \
    -e 's/blue/#268bd2/g' \
    -e 's/yellow/#657b83/g' \
    -e 's/brown/#b58900/g' \
    -e 's/brightgreen/#586e75/g' \
    -e 's/green/#859900/g' \
    -e 's/brightred/#cb4b16/g' \
    -e 's/red/#dc322f/g' \
    -e 's/gray/#002b36/g' \
    -e 's/black/#073642/g' \
    -e 's/edit#fdf6e3space/editwhitespace/'  # :P
