#!/bin/bash

source .env/vars.sh
source common/sources.sh

# Define the help function
help() {
    echo "Usage: ./setup.sh [command]"
    echo
    echo "Commands:"
    echo "  first-run      Run after download"
    echo "  init           Run the initialize function"
    echo "  update         Run the update function"
    echo "  help           Display this help message"
    echo "  make:links     Make symlinks for packages"
    echo "  make:file      Generate source files for the package"
    echo
    echo "If no command is provided, 'help' will be run by default."
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
	local script_dir="$PATH_DEVENV"
	local list=(".dotfiles" ".polskie.sh")
    local shared_dir=".shared"
    local source_path=""
    local dest_path=""
	# list+=(package2)

    # Share from devenv to packages
	# Loop through each element in the array
	for item in "${list[@]}"; do
        local sub_dir="$shared_dir/.devenv"
        local package_source="$script_dir/packages/$item"
		create_symlink "$package_source" "$HOME/$item"

        if [[ -d "$package_source" ]]; then
            local list2=("docker" ".todo" ".local" ".env" ".output")
            for item2 in "${list2[@]}"; do
                create_directories "$package_source/$sub_dir"
                create_symlink "$script_dir/$item2" "$package_source/$sub_dir/$item2"
            done
        fi

        if [[ -d "$script_dir/common" ]]; then
            create_symlink "$script_dir/common" "$package_source/$sub_dir/common"
        fi
	done

    # Share from package to packages
    local list_copy=(".dotfiles" ".polskie.sh")
    local package_shared=(".env" ".output")
    for item3 in "${list[@]}"; do
        for item4 in "${list_copy[@]}"; do
            if [ "$item3" != "$item4" ]; then
                local src="$script_dir/packages/$item3"
                local dest="$script_dir/packages/$item4/$shared_dir/$item3"
                create_directories "$dest"
                for package_shared_item in "${package_shared[@]}"; do
                    if [ -e "$src/$package_shared_item" ]; then
                        create_symlink "$src/$package_shared_item" "$dest/$package_shared_item"
                    fi
                done
            fi
        done
    done

    # Make sure symlink of compiled sources from $list have a copy in root directory
    create_symlink "$PATH_DEVENV/.output/sources.sh" "$HOME/.devenv.sources.sh"
}

makedirs() {
    create_directories "$ENV_TMP_DIR/$ENV_TMP_CACHE"
    create_directories "$ENV_TMP_DIR/$ENV_TMP_LIST"
    create_directories "$ENV_TMP_DIR/$ENV_TMP_STATE"
    create_directories "$ENV_TMP_DIR/$ENV_TMP_PREVIOUS_STATE"
    create_directories "$ENV_TMP_DIR/$ENV_TMP_HISTORY"
    create_directories "$ENV_TMP_DIR/$ENV_TMP_OTHERS"
    create_directories "$ENV_TMP_TODO_READ_DIR"
    create_directories "$ENV_TMP_TODO_REFERENCE"
}

makefile() {
    local script_dir="$PATH_DEVENV"
    local output_dir="$script_dir/.output"
    local output_file="$output_dir/sources.sh"

    # Ensure the output directory exists
    if [[ ! -d "$(realpath "$output_dir")" ]]; then
        mkdir -p "$output_dir"
        echo "Create: $output_dir directory"
    fi

	list=(".dotfiles" ".polskie.sh")

    > "$output_file"  # Clear the file first

    echo "#!/bin/bash" >> "$output_file"
    echo "" >> "$output_file"
    echo "echo \"Loaded: .devenv/sources.sh\"" >> "$output_file"
    echo "" >> "$output_file"

    local env_file="$PATH_DEVENV/.env/vars.sh"
    env_file=$(replace_home_path "$env_file")
    echo "[[ ! -f \"$env_file\" ]] || source \"$env_file\"" >> "$output_file"
    
    # Add env files first
	# Loop through each item in the array
	for item in "${list[@]}"; do
        local source_file=".env/vars.sh"
        local package_source="$script_dir/packages/$item"
        local source_file_path="$package_source/$source_file"

        # source_file_path=$(realpath "$source_file_path")
        source_file_path=$(replace_home_path "$source_file_path")
        echo "[[ ! -f \"$source_file_path\" ]] || source \"$source_file_path\"" >> "$output_file"
	done

    echo "" >> "$output_file"
	# Loop through each item in the array
	for item in "${list[@]}"; do
        local source_file=".output/sources.sh"
        local package_source="$script_dir/packages/$item"
        local source_file_path="$package_source/$source_file"

        # source_file_path=$(realpath "$source_file_path")
        source_file_path=$(replace_home_path "$source_file_path")

        echo "[[ ! -f \"$source_file_path\" ]] || source \"$source_file_path\"" >> "$output_file"
	done
}

first_run() {
    initialize
    deploy
}

add_to_startup_files() {
    local list=("$HOME/.bashrc" "/etc/bash.bashrc" "$HOME/.zshrc")
    local marker="Install script .devenv"
    local start_marker="# $marker @start"
    local end_marker="# $marker @end"
    local install_script=$(cat <<'EOF'
[[ ! -f $(realpath "$HOME/.devenv.sources.sh") ]] || source $(realpath "$HOME/.devenv.sources.sh")
EOF
  )
    for item in "${list[@]}"; do
        if [ -f "$item" ]; then
            # Check if the start marker is not present in the .bashrc
            if ! grep -q "$start_marker" "$item"; then
            {
                echo ""
                echo "$start_marker"
                echo "$install_script"
                echo "$end_marker"
                echo ""
            } >> "$item"
                echo "Install script for .devenv added to $item"
                if [ "$item" != "$HOME/.zshrc" ]; then
                    source "$item"
                fi
            else
                echo "Install script for .devenv already exist in $item"
            fi
        fi
    done
}

remove_to_startup_files() {
    local list=("$HOME/.bashrc" "/etc/bash.bashrc" "$HOME/.zshrc")
    local marker="Install script .devenv"
    local start_marker="# $marker @start"
    local end_marker="# $marker @end"

    for item in "${list[@]}"; do
        if [ -f "$item" ]; then
            # Check if the start marker is present in the .bashrc
            if grep -q "$start_marker" "$item"; then
                # Use sed to delete the lines between start and end markers, including the markers
                sed -i "/$start_marker/,/$end_marker/d" "$item"
                echo "Install script for .devenv removed from $item"
                if [ "$item" != "$HOME/.zshrc" ]; then
                    source "$item"
                fi
            else
                echo "Install script for .devenv not found in $item"
            fi
        fi
    done
}

deploy() {
    makedirs
    makefile
    make_symlinks
}

docker_console() {
    docker run --rm -it "devenv-test" bash
}

docker_start() {
    ./docker/start.docker.sh
}

# Check the parameter and call the corresponding function
if [ -z "$1" ]; then
    # No parameter passed, default to help
    help
else
    # Parameter passed, execute the corresponding function
    case "$1" in
		"help")
			help
			;;
        "init")
            initialize
            ;;
        "update")
            update
            ;;
        "make:file")
            makefile
            ;;
        "make:links")
            make_symlinks
            ;;
        "make:dirs")
            makedirs
            ;;
        "first-run")
            first_run
            ;;
        "add:onstartup")
            add_to_startup_files
            ;;
        "remove:onstartup")
            remove_to_startup_files
            ;;
        "docker:start" | "d:s")
            docker_start
            ;;
        "docker:console" | "d:c")
            docker_console
            ;;
        *)
            echo "Invalid parameter. Usage: ./setup.sh ["first-run"|init|update|"make:links"|"make:file"]"
            exit 1
            ;;
    esac
fi