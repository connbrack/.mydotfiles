#!/bin/bash



txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtblu='\e[0;34m' # Blue
txtcyn='\e[0;36m' # Cyan
NO_FORMAT="\033[0m"


trap 'echo "Caught SIGINT, exiting..."; exit' SIGINT

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FILE_PATH="$SCRIPT_DIR/packages.sh"
readarray -t packages < <(grep -vE '^#|^$' $FILE_PATH)

current_packages_json=$(nix profile list --json)
readarray -t current_packages < <(echo "$current_packages_json" | jq -r '.elements | keys[]')

echo
echo -e "----- ${txtblu}Syncing packages${NO_FORMAT} -----"
echo

sync=true
# Find items in packages not in current_packages
for package in "${packages[@]}"; do
    if [[ ! " ${current_packages[*]} " =~ " $package " ]]; then

        echo -e "-> ${txtcyn}Installing${NO_FORMAT} $package"
        nix profile install nixpkgs\#$package
        sync=false
        echo
    fi
done

# Find items in current_packages not in packages
for current_package in "${current_packages[@]}"; do
    if [[ ! " ${packages[*]} " =~ " $current_package " ]]; then
        echo -e "-> ${txtred}Removing${NO_FORMAT} $current_package"
        nix profile remove $current_package
        sync=false
        echo
    fi
done

if [ "$sync" = true ]; then
    echo -e "-> ${txtgrn}Package library already up to date${NO_FORMAT}"
    echo
fi

# Upgrade all packages:
echo -e "----- ${txtblu}Upgrading packages${NO_FORMAT} -----"
echo
for package in "${packages[@]}"; do
    nix profile upgrade $package

done

echo -e "-> ${txtgrn}All packages up to date${NO_FORMAT}"

