#!/bin/bash
yum update
yum -y install vim python-pip bison gcc make automake autoconf
pip install shadowsocks
yum -y install privoxy

echo '{
    "server":["XXX"],
    "server_port":39753,
    "local": "127.0.0.1",
    "local_port":7070,
    "password":"YYY",
    "timeout":60,
    "method":"rc4-md5"
}' > /etc/ss-local.json

nohup sslocal -c /etc/ss-local.json < /dev/null &>> /var/log/ss-local.log &

###############
### 全局代理 ###
###############
### 新建 whitelist.action 白名单文件
echo '
{{alias}}
# 代理(socks5)
socks5 = +forward-override{forward-socks5 127.0.0.1:7070 .}
# 直连
direct = +forward-override{forward .}

# 所有网站走代理
{socks5}
/

# 以下网站走直连
{direct}
' > /etc/privoxy/whitelist.action

### 加载 whitelist.action 文件
echo 'actionsfile whitelist.action' >> /etc/privoxy/config

### 启动 privoxy.service 服务
systemctl start privoxy.service
systemctl -l status privoxy.service

###############
### gfwlist ###
###############
### 获取 gfwlist2privoxy 脚本
curl -skL https://raw.github.com/zfl9/gfwlist2privoxy/master/gfwlist2privoxy -o gfwlist2privoxy

### 生成 gfwlist.action 文件
bash gfwlist2privoxy '127.0.0.1:7070'

### 拷贝至 privoxy 配置目录
cp -af gfwlist.action /etc/privoxy/

### 加载 gfwlist.action 文件
echo 'actionsfile gfwlist.action' >> /etc/privoxy/config

### 启动 privoxy 服务
systemctl start privoxy
systemctl -l status privoxy
