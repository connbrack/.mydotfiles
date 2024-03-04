#!/bin/bash

# Default behavior
skipupdate=0
nixless=0
node=0
conda=0

# Process flags
for arg in "$@"; do
  case $arg in
      --skip-update) skipupdate=1 ;;
      --nixless) nixless=1 ;;
      --node) node=1 ;;
      --conda) conda=1 ;;
      *) echo "Unknown option: $arg" exit 1 ;;
  esac
done

# ----------------------------- Functions ------------------------------------------

header() {
  echo && echo -e "\x1b[30;42m $1 \x1b[m"
}

apt-install() {
  dpkg -l | grep -qw $1 && echo $1 is already installed || sudo apt install $1 -y ; 
}

nix-install() {
  if nix-env -q $1 > /dev/null; then echo $1 is already installed; else nix-env -iA nixpkgs.$1; fi
}

# ----------------------------- Upgrade System ------------------------------------------


if [ ! $skipupdate -eq 1 ]; then
  header "Updating apt"

  sudo apt update
  sudo apt upgrade -y
fi

# ----------------------------- Basic Install -------------------------------------------

header "Installing Basic Packages"

apt-install build-essential
apt-install gawk
apt-install fzf
apt-install trash-cli
apt-install tmux

if [ -f "$HOME/.local/share/blesh/ble.sh" ]; then
  echo blesh is already installed
else
  apt-install make
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
  make -C ble.sh install PREFIX=~/.local
  sudo rm -r $HOME/.mydotfiles/ble.sh
fi

# -------------------------- Packages installs --------------------------------------------

header "Installing Main Packages"

if [ $nixless -eq 1 ]; then

  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim -y

  sudo apt install golang-go -y
  env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

else

  if command -v nix-env >/dev/null; then
      echo "nix-env is already installed."
  else
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
    . $HOME/.nix-profile/etc/profile.d/nix.sh
  fi

  nix-install neovim
  nix-install lf
  nix-install tldr

fi

# ----------------------------- Optional installs -------------------------------------------


if [ $node -eq 1 ]; then
  header "Installing node"

  if command -v node >/dev/null 2>&1; then
      echo "Node.js is installed"
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install --lts
    npm install -g yarn
  fi
fi

if [ $conda -eq 1 ]; then
  header "Installing conda"

  if command -v conda >/dev/null 2>&1; then
      echo "conda is installed"
  else
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
  fi
fi



# ------------------------ Other usefull install scripts --------------------------------------


## Create swap storage - https://www.youtube.com/watch?v=i7q8JbNK-9s
#sudo dd if=/dev/zero of=/mnt/swapfile bs=1024 count=2097152
#sudo fallocate --length 2GiB /mnt/swapfile
#sudo mkswap /mnt/swapfile
#sudo swapon /mnt/swapfile
