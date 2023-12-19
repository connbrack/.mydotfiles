#!/bin/bash

# ----------------------------- Install tools -------------------------------------------

sudo apt install tldr
sudo apt install fzf
sudo apt install trash-cli


# Install neovim
sudo apt install neovim

# Install lf
sudo apt install golang-go
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

# Install ble
sudo apt install make
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local


sudo apt install gtk3-nocsd
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0

