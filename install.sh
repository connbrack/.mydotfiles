#!/bin/bash

# ----------------------------- Example Uses ------------------------------------------
#
# all flags:
# ./install.sh --essential-packages --terminal-packages --nix-packages --blesh --docker --js --py --vagrant
#
# ----------------------------- Flags ------------------------------------------

essential=0
termpac=0
nixpac=0
blesh=0
docker=0
js=0
py=0
vagrant=0

# Process flags
for arg in "$@"; do
  case $arg in
  --essential-packages) essential=1 ;;
  --terminal-packages) termpac=1 ;;
  --nix-packages) nixpac=1 ;;
  --blesh) blesh=1 ;;
  --docker) docker=1 ;;
  --js) js=1 ;;
  --py) py=1 ;;
  --vagrant) vagrant=1 ;;
  *)
    echo "Unknown option: $arg"
    exit 1
    ;;
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
# essential packages
if [ $essential -eq 1 ]; then
  if [ $packagemanager = "apt" ]; then
    header "Installing essential packages"

    sudo apt install -y \
      software-properties-common build-essential \
      git curl make ripgrep gawk trash-cli \
      xclip xsel
  else
    sudo dnf install -y \
      git curl make trash-cli ripgrep
    sudo dnf install @development-tools
  fi

fi

if [ $packagemanager = "apt" ] && [ $termpac -eq 1 ]; then

  header "Installing apt packages"

  # nvim
  sudo add-apt-repository ppa:neovim-ppa/unstable -y &&
    sudo apt update &&
    sudo apt install -y neovim

  # lf
  sudo apt install golang-go -y &&
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
  batcat cache --build

  # fd
  sudo apt install -y fd-find
  mkdir -p ~/.local/bin
  ln -s $(which fdfind) ~/.local/bin/fd
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

  # bat
  sudo dnf install bat
  bat cache --build

  # fd-find
  sudo dnf install fd-find
fi

if [ $nixpac -eq 1 ]; then
  header "Installing Nix"
  if command -v nix >/dev/null; then
    echo "nix is already installed."
  else
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    nix profile add github:nix-community/home-manager
    home-manager switch --flake $HOME/.mydotfiles/misc/home-manager --impure
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

if [ $js -eq 1 ]; then
  header "Installing node"
  if [ -d "$HOME/.nvm" ]; then
    echo "nvm is already installed"
  else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install --lts
    npm install -g yarn
  fi
fi

if [ $py -eq 1 ]; then
  header "Installing uv for python"
  if command -v uv >/dev/null 2>&1; then
    echo "uv is already installed"
  else
    if [ $packagemanager = "apt" ]; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
    else
      sudo dnf install -y uv
    fi

    mkdir ~/.uv
    uv --directory ~/.uv venv
  fi
fi

if [ $docker -eq 1 ]; then
  header "Installing docker"
  if command -v docker >/dev/null 2>&1; then
    echo "docker is already installed"
  else
    if [ $packagemanager = "apt" ]; then
      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
      sudo apt-get update
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
      sudo dnf -y install dnf-plugins-core
      sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
      sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi

    # Post install
    sudo groupadd docker
    sudo usermod -aG docker $USER
  fi
fi

if [ $vagrant -eq 1 ]; then
  header "Installing vagrant"
  if command -v vagrant >/dev/null 2>&1; then
    echo "vagrant is already installed"
  else

    if [ $packagemanager = "apt" ]; then
      echo "No install script implemented for apt"
    else
      sudo dnf install @virtualization @vagrant
      sudo systemctl enable --now virtqemud.service
      sudo systemctl enable --now virtnetworkd.service
      sudo usermod -aG libvirt $USER
    fi
  fi
fi
