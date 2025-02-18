#!/bin/sh

tmp_name=`mktemp "/tmp/locale_test_XXXXXXXXXXXXXXXX"`
tmp_c_file=$tmp_name.c
tmp_bin_file=$tmp_name.elf

cat > "$tmp_c_file" << EOF
#include <stdio.h>
#include <locale.h>
#include <langinfo.h>

int main()
{
    setlocale (LC_ALL, "");
    printf ("CODESET: '%s'\n", nl_langinfo (CODESET));
    return 0;
}
EOF

gcc $tmp_c_file -o $tmp_bin_file
$tmp_bin_file
rm -f $tmp_c_file $tmp_bin_file $tmp_name
