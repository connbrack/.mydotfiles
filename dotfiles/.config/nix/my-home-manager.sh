#/bin/bash



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

# Find items in packages not in current_packages
new_packages=false
combined=""
combined_label=""
for package in "${packages[@]}"; do
    if [[ ! " ${current_packages[*]} " =~ " $package " ]]; then
        combined_label+="${package} "
        combined+="nixpkgs#${package} "
        new_packages=true
    fi
done

if [[  "$new_packages" == true  ]]; then
  echo -e "-> Installing: ${txtcyn}$combined_label${NO_FORMAT}"
  nix profile install $combined
  echo
fi

# Find items in current_packages not in packages
packages_removed=false
combined=""
combined_label=""
for current_package in "${current_packages[@]}"; do
    if [[ ! " ${packages[*]} " =~ " $current_package " ]]; then
        combined_label+="${current_package} "
        combined+="${current_package} "
        packages_removed=true
    fi
done

if [[ "$packages_removed" == true ]]; then
  echo -e "-> Removing: ${txtred}$combined${NO_FORMAT}"
  nix profile remove $combined
  echo
fi

if [[ "$new_packages" == false || "$packages_removed" == true ]]; then
    echo -e "-> ${txtgrn}Package library already up to date${NO_FORMAT}"
    echo
fi

# Upgrade all packages:
echo -e "----- ${txtblu}Upgrading packages${NO_FORMAT} -----"
echo

combined=""
for package in "${packages[@]}"; do
    combined+="${package} "
done
nix profile upgrade $combined

echo -e "-> ${txtgrn}All packages up to date${NO_FORMAT}"
