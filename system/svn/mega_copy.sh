#!/bin/bash
#######################################################################
# usage: 
# author: sam <sam42@outlook.com>
#######################################################################

_source=$1;
while :
do
    if [ ! "$_source" ]; then
        read -p "please input exist source folder:" _source;
    else
        break
    fi
done

_target=$2;
while :
do
    if [ ! "$_target" ]; then
        read -p "please input exist target folder:" _target;
    else
        break
    fi
done

while read line; do
    /cp $_source/$line $_target/$line;
done