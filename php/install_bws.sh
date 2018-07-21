#!/bin/bash
extname="bws";
prog_path="/root/php_ext/Bws";
if [ $1 ];then
	if [ -d "/root/php_ext/Bws/tests/$1" ];then
		files_option="-d /root/php_ext/Bws/tests/$1"
	else
		files_option="-f $1"
	fi
fi
/root/tools/php/install_php_ext.sh -p $prog_path -e $extname $files_option
