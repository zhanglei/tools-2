#!/bin/bash
#######################################################################
# usage: url -n{count}
# description: statistics of curl response time 
# author: sam <sam42@outlook.com>
#######################################################################
url=$1;
shift;
while :
do
    if [ "$url" != "" ];then
        break
    else
        read -p "please input url:" url;
    fi
done
while getopts "n:" arg
do
    case $arg in
        n)  
            count=$OPTARG;
            ;;  
        ?)  
            help
            exit 1;
            ;;  
    esac
done

if [ ! $count ]; then
	count=10;
fi
times=();
times_total=0;
for((i=1;i<=$count;i++));do
	times[$i]=$(curl -o /dev/null -s -w %{time_total} "$url");
done

line='';
for((i=1;i<=$count;i++));do
    line=$line"========";
done
n=1;
timeline='';
for time in ${times[@]}
do
    if [ $n -eq $count ];then
        timeline=$timeline"$time";
    else
        timeline=$timeline"$time | ";
    fi
    times_total=$(echo "$times_total+$time"|bc);
    ((n++))
done
times_avg=$(echo "scale=3; $times_total/$count"|bc);


echo -e $line"\n";
echo -e " send request "$count" times (unit:sec)\n";
echo -e $line"\n";
echo -e " "$timeline"\n";
echo -e $line"\n";
echo -e " avg $times_avg sec \n";
echo -e $line"\n";
