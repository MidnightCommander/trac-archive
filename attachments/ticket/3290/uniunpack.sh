#! /bin/sh

# Universal Unpacker by Artem S. Tashkinov
# v1.4.0 Oct 18 15:35 2014: total rewrite; proper gzip support; no command output :(
# v1.4.1 Oct 26 13:20 2014: file extension normalized
# v1.4.2 Nov 4  04:29 2014: use RAR by default, use -r- for RAR, BASH->SH
# v1.4.3 Mar 7  22:02 2015: use UNRAR by default
# v1.4.4 Tue 04 Nov 2019 01:18:27: prefer p7zip for zip archives

test -z "$1" && echo "Need an archive name to proceed" && exit 1
test ! -e "$1" && echo "File '$1' doesn't exist" && exit 1

lower=$(echo "$1" | tr A-Z a-z)

case "$lower" in
    *.tar|*.tbz|*.txz|*.tgz|*.tar.bz2|*.tar.gz|*.tar.xz|*.tar.lz)
        tar xf "$1"
        ;;
    *.rar)
        unrar x -r- "$1"
        ;;
    *.7z)
        7z x "$1"
        ;;
    *.bz2)
        bzip2 -kd "$1"
        ;;
    *.gz)
        gunzip -k "$1"
        ;;
    *.xz)
        xz -dk "$1"
        ;;
    *.zip)
        if 7z &> /dev/null; then
            7z x "$1"
        else
            unzip "$1"
        fi
        ;;
    *.cpio)
        cpio -i -m -d -F "$1"
        ;;
    *)
        echo "The archive type for '$1' is unknown"
        echo -n "Would you like to try unpacking the archive using 7z (y/n)? "
        read answer
        test "$answer" = "Y" -o "$answer" = "y" && 7z x "$1"
        ;;
esac

res=$?
test "$res" -ne 0 && echo "WARNING: Unpacking failed!"
exit "$res"
