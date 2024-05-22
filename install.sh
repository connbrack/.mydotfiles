#!/bin/bash

# Default behavior
skipupdate=0
blesh=0
nixpac=0
aptpac=0
desktop=0
node=0
pyenv=0

# Process flags
for arg in "$@"; do
  case $arg in
      --skip-update) skipupdate=1 ;;
      --blesh) blesh=1 ;;
      --nixpac) nixpac=1 ;;
      --apt-packages) aptpac=1 ;;
      --desktop) desktop=1 ;;
      --node) node=1 ;;
      --pyenv) pyenv=1 ;;
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

# ----------------------------- Upgrade System ------------------------------------------


if [ ! $skipupdate -eq 1 ]; then
  header "Updating apt"

  sudo apt update
  sudo apt upgrade -y
fi

# ----------------------------- Basic Install -------------------------------------------

header "Installing Basic Packages"

apt-install curl
apt-install build-essential
apt-install build-essential
apt-install gawk
apt-install trash-cli
apt-install bat
apt-install tmux

if [ $blesh -eq 1 ]; then
  header "Installing blesh"
  if [ -f "$HOME/.local/share/blesh/ble.sh" ]; then
    echo blesh is already installed
  else
    apt-install make
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
    sudo rm -r $HOME/.mydotfiles/ble.sh
  fi
fi

if [ $desktop -eq 1 ]; then
  header "Installing Desktop Packages"
  apt-install xclip
  apt-install xsel
  apt-install xdotool
  apt-install xbindkeys
  apt-install latte
  apt-install rofi
  sudo apt install rofi-dev autoconf automake libtool-bin libtool
fi

# -------------------------- Packages installs --------------------------------------------

if [ $aptpac -eq 1 ]; then
  header "Installing apt packages"
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim -y

  sudo apt install golang-go -y
  env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
fi


if [ $nixpac -eq 1 ]; then
  header "Installing Nix"
  if command -v nix >/dev/null; then
      echo "nix is already installed."
  else
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    cp -r ~/.mydotfiles/Nix/ ~/
    ~/Nix/my-home-manager.sh
  fi
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

if [ $pyenv -eq 1 ]; then
  header "Installing pyenv"

  if command -v pyenv >/dev/null 2>&1; then
      echo "pyenv is installed"
  else
    curl https://pyenv.run | bash
    sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
  fi
fi


# ------------------------ Other usefull install scripts --------------------------------------


## Create swap storage - https://www.youtube.com/watch?v=i7q8JbNK-9s
#sudo dd if=/dev/zero of=/mnt/swapfile bs=1024 count=2097152
#sudo fallocate --length 2GiB /mnt/swapfile
#sudo mkswap /mnt/swapfile
#sudo swapon /mnt/swapfile
