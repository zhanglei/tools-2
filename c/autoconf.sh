#!/bin/bash
while getopts "n:" arg
do
    case $arg in
        n)  
            name=$OPTARG
            ;;  
        ?)  
            help
            exit 1;
            ;;
    esac
done
while :
do
    # Set mysql install flag
    read -p "Please input application name :" name
    if [ $name != "" ];then
        break
    fi
done
mkdir $name;
cd $name;
# prepare sample file
cat > $name.c <<EOF
#include <stdio.h>

#include "config.h"

int main() {
    printf("Success! $name is created! enjoy it!\n");
}
EOF
cat > config.h <<EOF

#ifndef CONFIG_H
#define CONFIG_H

#define VERSION 1.0

#endif
EOF
# configure.in
autoscan
mv configure.scan configure.ac
cat > configure.ac <<EOF 
# -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_INIT($name.c)
AM_INIT_AUTOMAKE($name, 1.0)
 
# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_OUTPUT(Makefile)
EOF

aclocal
autoconf
cat > Makefile.am <<EOF 
AUTOMAKE_OPTIONS = foreign
noinst_PROGRAMS = $name
${name}_SOURCES = $name.c
# -I/includes/
${name}_CFLAGS =
# -L/lib
${name}_LDFLAGS =
# -lfoo.la
${name}_LDADD = 
# -lfoo
LIBS =
EOF

automake --add-missing
