#!/bin/bash

# Define the help function
help() {
    echo "Usage: ./setup.sh [command]"
    echo
    echo "Commands:"
    echo "  initialize     Run the initialize function"
    echo "  update         Run the update function"
    echo "  help           Display this help message"
    echo "  make:links     Make symlinks for packages"
    echo
    echo "If no command is provided, 'initialize' will be run by default."
}

# Define the initialize function
initialize() {
    echo "Running initialize function..."
	git submodule init
	git submodule update --remote --merge
}

# Define the update function
update() {
    echo "Running update function..."
	git submodule foreach git fetch
	git submodule foreach git pull origin $(git rev-parse --abbrev-ref HEAD)
}

make_symlinks() {
    echo "Creating symlinks..."
	local script_dir=$(dirname "$(readlink -f "$0")")
	local list=(".dotfiles" ".polskie.sh")
	
	# list+=(package2)
	# Loop through each element in the array
	for element in "${list[@]}"; do
		local target_dir="$HOME/$element"
		local symlink_target="$script_dir/packages/$element"

		__create_symlink "$target_dir" "$symlink_target"
	done
}

# Define the function to check and create a symlink
__create_symlink() {
    local target_dir="$1"
    local symlink_target="$2"

    if [ -e "$target_dir" ]; then
        if [ -L "$target_dir" ]; then
            echo "$target_dir is already a symlink."
        else
            echo "Error: $target_dir already exists as a directory."
        fi
    else
        echo "$target_dir is not a symlink. Creating a symlink..."
        ln -s "$symlink_target" "$target_dir"
        echo "Symlink created from $target_dir to $symlink_target."
    fi
}

# Check the parameter and call the corresponding function
if [ -z "$1" ]; then
    # No parameter passed, default to initialize
    initialize
else
    # Parameter passed, execute the corresponding function
    case "$1" in
		help)
			help
			;;
        init)
            initialize
            ;;
        "make:links")
            make_symlinks
            ;;
        update)
            update
            ;;
        *)
            echo "Invalid parameter. Usage: ./setup.sh [init|update|"make:links"]"
            exit 1
            ;;
    esac
fi