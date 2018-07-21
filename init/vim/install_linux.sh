#!/bin/bash

# install dependencies
yum -y install vim git ctags cscope gawk

rpm -i sources/id-utils-4.2-x86_64.rpm

sudo git clone https://github.com/exvim/main

cd main
sudo sh unix/install.sh
sudo sh unix/replace-my-vim.sh
cd ..

echo "set shiftwidth=4
set mouse=" >> ~/.vimrc.local

#rm -rf main
