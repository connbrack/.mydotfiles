#!/bin/bash


# ----------------------------- Upgrade System ------------------------------------------
sudo apt update && 
sudo apt upgrade -y &&

# ----------------------------- Basic Install -------------------------------------------
sudo apt install fzf -y
sudo apt install trash-cli -y

# Install ble
sudo apt install make -y
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local


# ----------------------------- Nix installs ------------------------------------------------
curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.lf
nix-env -iA nixpkgs.tldr

# ----------------------------- Optional installs -------------------------------------------

## npm packages 
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
#export NVM_DIR="$HOME/.nvm"
#source ~/.bashrc
#nvm install --lts

#mkdir -p ~/miniconda3
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
#bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
#rm -rf ~/miniconda3/miniconda.sh
#~/miniconda3/bin/conda init bash

## Create swap storage - https://www.youtube.com/watch?v=i7q8JbNK-9s
#sudo dd if=/dev/zero of=/mnt/swapfile bs=1024 count=2097152
#sudo fallocate --length 2GiB /mnt/swapfile
#sudo mkswap /mnt/swapfile
#sudo swapon /mnt/swapfile
