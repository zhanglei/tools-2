#!/bin/bash
#to be called,use “source string.sh” or “. string.sh”

#计算字符串长度
function strlen()
{
    str=$1
    echo ${#str}
}

#获取子串
function substr()
{
    str=$1
    echo ${str:$2:$3}
    #or
    #echo $str | cut -c$2-$3
}

#查找子串位置
#to get result,use it like this: res=`strpos ‘abcd1234′ ’123′`
function strpos()
{
    echo $(echo $1 $2|awk ‘{print index($1, $2)}’)
}

#字符串替换
function str_replace()
{
    echo $1 | sed “s/$2/$3/g”
}

#取给定时间的前一天
#get the date before $1
function get_day_before()
{
    seconds=`date -d $1 +%s`       #get seconds of given date
    seconds_yesterday=$((seconds – 86400))
    day_before=`date -d @$seconds_yesterday +%F`
    echo $day_before
}

#删除空行
function delete_empty_line()
{
    sed -e ‘/^$/d’ $1
}
#urlendcode
function urlencode()
{
    content=$1
    x=”
    content=`echo -n “$content” | od -An -tx1 | tr ‘ ‘ %`
    for i in $content
    do
              x=$x$i;
    done
    content=$x
    echo $content;
}
