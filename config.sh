#bin/bash

# Default behavior
force=0; 

# Process flags
for arg in "$@"; do
  case $arg in
      -f) force=1 ;;
      *) echo "Unknown option: $arg" exit 1 ;;
  esac
done

# ----------------------------- Link Configuration Files -------------------------------------------

link_file_to_home() {
    local source_file=$1$2
    local target_link="$HOME/$2"

    if [ "$(readlink -f "$target_link")" == "$source_file" ]; then
      return 0
    fi
    
    if [ $force -eq 1 ]; then
      ln -sf "$source_file" "$target_link" && echo "Link created: $target_link -> $source_file"
    else
      ln -s "$source_file" "$target_link" && echo "Link created: $target_link -> $source_file"
    fi
}

# --------------------------------- Options -------------------------------------------------

dotfilelocations="$HOME/.mydotfiles/dotfiles/"
files_to_link=(
	".bashrc" 
	".bash" 
	".blerc" 
  ".gitconfig"
  ".config/bat"
  ".config/bottom"
  ".config/lf"
  ".config/nvim"
  ".config/starship.toml"
  ".config/tmux"
  #".config/rofi"
)

# --------------------------------- Run script -------------------------------------------------

# Make .config file if it does not exist
if ! [ -d "$HOME/.config" ]; then
  mkdir $HOME/.config
fi

# Main script 
for file in "${files_to_link[@]}"; do
    link_file_to_home "$dotfilelocations" "$file"
done

if command -v tmux >/dev/null 2>&1; then
  if ! [ -d $HOME/.local/share/tmux/plugins ]; then
    mkdir -p $HOME/.local/share/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm $HOME/.local/share/tmux/plugins/tpm
  fi
fi

if command -v bat >/dev/null 2>&1; then
  \bat cache --build
fi

if [ -d $HOME/miniconda3 ]; then
    ~/miniconda3/bin/conda init bash
fi
