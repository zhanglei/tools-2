#!/bin/bash

# install dependencies
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install macvim ctags gawk idutils
brew linkapps macvim

sudo git clone https://github.com/exvim/main

cd main
sudo sh osx/install.sh
sudo sh osx/replace-my-vim.sh
cd ..

echo "set shiftwidth=4" >> ~/.vimrc.local

#rm -rf main
