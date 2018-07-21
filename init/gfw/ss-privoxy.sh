#!/bin/bash
#proxy
PRIVOXY='127.0.0.1:8118'
defp=$PRIVOXY
# No Proxy
function noproxy
{
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY ftp_proxy FTP_PROXY dns_proxy DNS_PROXY JAVA_OPTS GRADLE_OPTS MAVEN_OPTS
    echo "clear proxy done"
}

function setproxy
{
    if [ $# -eq 0 ]
    then
        inArg=$defp
    else
        inArg=$1
    fi
    PROXY_HOST=$(echo $inArg |cut -d: -f1)
    PROXY_PORT=$(echo $inArg |cut -d: -f2)
    http_proxy=http://$PROXY_HOST:$PROXY_PORT
    HTTP_PROXY=$http_proxy
    all_proxy=$http_proxy
    ALL_PROXY=$http_proxy
    ftp_proxy=$http_proxy
    FTP_PROXY=$http_proxy
    dns_proxy=$http_proxy
    DNS_PROXY=$http_proxy
    https_proxy=$http_proxy
    HTTPS_PROXY=$https_proxy
    JAVA_OPTS="-Dhttp.proxyHost=$HOST -Dhttp.proxyPort=$PORT -Dhttps.proxyHost=$HOST -Dhttps.proxyPort=$PORT"
    GRADLE_OPTS="-Dgradle.user.home=$HOME/.gradle"
    MAVEN_OPTS=$JAVA_OPTS
    no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com,.github.com"
    echo "current proxy is ${http_proxy}"
    export no_proxy http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY ftp_proxy FTP_PROXY dns_proxy DNS_PROXY JAVA_OPTS GRADLE_OPTS MAVEN_OPTS
}

case $1 in
start)
    nohup sslocal -c /etc/ss-local.json < /dev/null &>> /var/log/ss-local.log &
    systemctl start privoxy
    setproxy $2
    ;;
stop)
    unset http_proxy https_proxy no_proxy
    systemctl stop privoxy
    pkill sslocal
    ;;
reload)
    pkill sslocal
    nohup sslocal -c /etc/ss-local.json < /dev/null &>> /var/log/ss-local.log &
    ;;
set)
    setproxy $2
    ;;
unset)
    noproxy
    ;;
*)
    echo "usage: source $0 start|stop|reload|set|unset"
    exit 1
    ;;
esac

###############
### 设置别名 ###
###############
alias ss.start='. ss-privoxy start'
alias ss.stop='. ss-privoxy stop'
alias ss.reload='. ss-privoxy reload'
alias ss.set='. ss-privoxy set'
alias ss.unset='. ss-privoxy unset'