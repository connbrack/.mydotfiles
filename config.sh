#bin/bash

# ----------------------------- Link Configuration Files -------------------------------------------

link_file_to_home() {
    local file=$2
    local source_file=$1$2
    local target_link="$HOME/$2"

    # Check if the file already exists in the home directory
    if [ -L "$target_link" ]; then
        # Check if the existing link points to the same file
        if [ "$(readlink -f "$target_link")" == "$source_file" ]; then
            echo "The link for '$file' already exists. No further action is needed."
        else
            echo "A link for '$file' already exists but points to a different file. Please remove link and re-run script."
        fi
    elif [ -e "$target_link" ]; then
        # Backup the existing file
        echo "A file for '$file' already exists. Please remove or rename file and re-run script.."
    else
        # Create a symbolic link in the home directory
        ln -s "$source_file" "$target_link"
        echo "Link created: $target_link -> $source_file"
    fi

}

dotfilelocations="$HOME/.mydotfiles/dotfiles/"
files_to_link=(
	".bashrc" 
	".blerc" 
	".config/nvim" 
	".config/lf" 
)

for file in "${files_to_link[@]}"; do
    link_file_to_home "$dotfilelocations" "$file"
done
