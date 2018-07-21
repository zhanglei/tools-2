#!/bin/bash
#######################################################################
# usage: [svn path] version [version](version to compare) [ignore_version]
# P.S. if there is only one arguments it will export the change of this version
# description: export svn change files from multiple version
# author: sam <sam42@outlook.com>
#######################################################################
function gen_files() {
    if [ $# -eq 0 ];then
        tmp_files=$(svn st | awk '{if($1 == "A" || $1 == "M" || $1 == "G") {print $2} }')
        path=$(pwd);
    elif [ $# -eq 1 ];then
        tmp_files=$(svn diff -c $1 --summarize | awk '{if($1 == "A" || $1 == "M" || $1 == "G") {print $2} }')
        path=$1;
    elif [ $# -eq 2 ];then
        tmp_files=$(svn diff -r $1:$2 --summarize | awk '{if($1 == "A" || $1 == "M" || $1 == "G") {print $2} }')
        path=$1;
    elif [ $# -gt 2 ];then
        tmp_files=$(svn diff -r $1:$2 --summarize | awk '{if($1 == "A" || $1 == "M" || $1 == "G") {print $2} }')
        path=$1;
        shift;
        shift;
        n=0;
        for ignore in $@; do
            tmp_ignore_files=$(svn diff -c $ignore --summarize | awk '{if($1 == "A" || $1 == "M" || $1 == "G") {print $2} }')
            for tmp_file in $tmp_ignore_files; do
                new_file="true";
                for ignore_file in ${ignore_files[@]}; do
                    if [ $ignore_file == $tmp_file  ]; then
                        new_file="false";
                        break;
                    fi
                done
                if [ $new_file == "true" ]; then
                    ignore_files[$n]=$tmp_file;
                    ((n++));
                fi
            done
        done
    fi
    n=0;
    for tmp_file in $tmp_files; do
        ignore_file="false";
        for file in ${ignore_files[@]}; do
            if [ $file == $tmp_file ]; then
                ignore_file="true";
                break;
            fi
        done
        if [ $ignore_file == "false" ]; then
            files[$n]=$tmp_file;
            ((n++));
        fi
    done
}

function output() {
  for file in ${files[@]}
  do
  echo $file;
  done
}
shift;
if [ $# -gt 0 ]; then
    while :
    do
        if [ ! -d "$1" ]; then
            read -p "please input exist path:" path;
        else
            path=$1;
            break
        fi
    done
fi
cd $path;
files=();
n=0;
if [ $# -eq 0 ]; then
    gen_files;
elif [ $# -eq 1 ]; then
    # export changes of a version
    gen_files $path;
elif [ $# -eq 2 ]; then
    # export changes between two versions
    gen_files $path $2;
elif [ $# -gt 2 ];then
    # export changes between two versions and ignore some versions
    gen_files $args;
fi
output;
