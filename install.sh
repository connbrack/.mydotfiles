#!/bin/bash

# ----------------------------- Install tools -------------------------------------------

sudo apt install tldr
sudo apt install fzf


# Install neovim
sudo apt install neovim

# Install lf
sudo apt install go
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

# Install ble
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
