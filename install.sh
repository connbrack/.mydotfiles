#!/bin/bash

# ----------------------------- Example Uses ------------------------------------------

# all flags:
# ./install.sh --essential-packages --terminal-packages --nix-packages --blesh --desktop --node --pyenv

# Terminal setup:
# ./install.sh --essential-packages --terminal-packages --terminal-packages --blesh

# Nix terminal setup:
# ./install.sh --essential-packages --nix-packages --blesh

# Coding setup:
# ./install.sh --docker --node --pyenv

# ----------------------------- Flags ------------------------------------------

essential=0
termpac=0
nixpac=0
blesh=0
docker=0
node=0
pyenv=0

# Process flags
for arg in "$@"; do
  case $arg in
      --essential-packages) essential=1 ;;
      --terminal-packages) termpac=1 ;;
      --nix-packages) nixpac=1 ;;
      --blesh) blesh=1 ;;
      --docker) docker=1;;
      --node) node=1 ;;
      --pyenv) pyenv=1 ;;
      *) echo "Unknown option: $arg"; exit 1 ;;
  esac
  shift
done

if command -v apt >/dev/null 2>&1; then
  packagemanager="apt"
elif command -v dnf >/dev/null 2>&1; then
  packagemanager="dnf"
else
  echo "No known package manager found (apt or dnf)"
  exit 1
fi

# ----------------------------- Functions ------------------------------------------

header() {
  echo && echo -e "\x1b[30;42m $1 \x1b[m"
}


# -------------------------- Terminal Packages Installs ----------------------------------
# essential packges
if [ $essential -eq 1 ]; then
  if [ $packagemanager = "apt" ]; then
    header "Installing essential packages"

    sudo apt install \
      software-properties-common build-essential \
      curl make ripgrep gawk trash-cli \
      xclip xsel xdotool -y
  else
    sudo dnf install \
      make trash-cli ripgrep
  fi

fi


if [ $packagemanager = "apt" ] && [ $termpac -eq 1 ]; then

    header "Installing apt packages"

    # nvim
    sudo add-apt-repository ppa:neovim-ppa/unstable -y &&\
    sudo apt update &&\
    sudo apt install -y neovim

    # lf
    sudo apt install golang-go -y &&\
    env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest

    # tmux
    sudo apt install -y tmux

    # fzf
    sudo apt install -y fzf

    # btm
    curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.7/bottom_0.9.7_amd64.deb
    sudo apt install -y ./bottom_0.9.7_amd64.deb
    rm ./bottom_0.9.7_amd64.deb

    # starship
    curl -sS https://starship.rs/install.sh | sh -s -- --yes

    # bat
    sudo apt install -y bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi

if [ $packagemanager = "dnf" ] && [ $termpac -eq 1 ]; then

    header "Installing dnf packages"
    
    # nvim
    sudo dnf -y neovim

    # lf
    sudo dnf copr enable -y pennbauman/ports
    sudo dnf install -y lf

    # tmux
    sudo dnf install -y tmux

    # fzf
    sudo dnf install -y fzf

    # btm
    sudo dnf copr enable -y atim/bottom
    sudo dnf -y install bottom

    # starship
    sudo dnf copr enable -y atim/starship
    sudo dnf install -y starship
fi


if [ $nixpac -eq 1 ]; then
  header "Installing Nix"
  if command -v nix >/dev/null; then
    echo "nix is already installed."
  elif [ -d "~/.config/home-manager" ]; then
    echo "~/.config/home-manager exists, delete or move this file before running"
  else
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    cp -r ~/.mydotfiles/misc/home-manager/ ~/.config/
    sed -i "s/__username__/$(whoami)/g" ~/.config/home-manager/home.nix
    home-manager switch
  fi
fi

# ----------------------------- Optional installs -------------------------------------------

if [ $blesh -eq 1 ]; then
  header "Installing blesh"
  if [ -f "$HOME/.local/share/blesh/ble.sh" ]; then
    echo "blesh is already installed"
  else
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
    sudo rm -r $HOME/.mydotfiles/ble.sh
  fi
fi

if [ $node -eq 1 ]; then
  header "Installing node"
  if [ -d "$HOME/.nvm" ]; then
      echo "pyenv is already installed"
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install --lts
    npm install -g yarn
  fi
fi

if [ $pyenv -eq 1 ]; then
  header "Installing pyenv"
  if [ -d "$HOME/.pyenv" ]; then
      echo "pyenv is already installed"
  else
    if [ $packagemanager = "apt" ];then
      sudo apt install build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev curl git \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
  else
      sudo dnf install -y gcc make patch zlib-devel bzip2 bzip2-devel readline-devel \
        sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    fi
    curl https://pyenv.run | bash
  fi
fi

if [ $docker -eq 1 ]; then
  header "Installing docker"
  if command -v docker >/dev/null 2>&1; then
    echo "docker is already installed"
  else
    if [ $packagemanager = "apt" ];then
      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
      sudo dnf -y install dnf-plugins-core
      sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
      sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
  fi
fi


# ------------------------ Other usefull install scripts --------------------------------------

## Clean up nix
#/nix/nix-installer uninstall
#rm ~/.local/state/nix/profiles/home-manager*
#rm ~/.local/state/home-manager/gcroots/current-home
#rm -r ~/.config/home-manager
#rm -r ~/.nix-*

## Install miniconda 
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
