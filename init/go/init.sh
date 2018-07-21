#!/bin/bash

### 安装gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

gvm install go1.4
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.7
gvm use go1.7 --default

### 设置全局GOPATH
export GOPATH=/data0/local/go
mkdir -p $GOPATH/src
cd $GOPATH
gvm pkgset create --local
gvm pkgset use --local
cd src
