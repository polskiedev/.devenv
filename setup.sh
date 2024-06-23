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
	local script_dir=$(dirname "$(readlink -f "$0")")
	local list=(".dotfiles" ".polskie.sh")
    local source_path=""
    local dest_path=""
	# list+=(package2)

	# Loop through each element in the array
	for item in "${list[@]}"; do
		source_path="$HOME/$item"
		dest_path="$script_dir/packages/$item"

		create_symlink "$HOME/$item" "$script_dir/packages/$item"
	done

    # Make sure symlink of compiled sources from $list have a copy in root directory
    create_symlink "$HOME/.devenv.sources.sh" "$PATH_DEVENV/.output/sources.sh"

    local repo_dir="$HOME/.polskie.sh"
    local sub_dir=".shared"

    if [[ -d "$repo_dir" ]]; then
        list=("docker" ".todo" ".local")
        for item in "${list[@]}"; do
            create_directories "$repo_dir/$sub_dir"
            create_symlink "$PATH_DEVENV/$item" "$repo_dir/$sub_dir/$item"
        done
    fi

    if [[ -d "$repo_dir/system" ]]; then
        create_symlink "$PATH_DEVENV/common/functions" "$repo_dir/system/common"
    fi
}

makefile() {
    local output_dir="$PATH_DEVENV/.output"
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

    # echo "if [ -z \"\$IS_SOURCED_DEVENV\" ]; then" >> "$output_file"
    # echo "  IS_SOURCED_DEVENV=true" >> "$output_file"
    # echo "  echo \"Loaded: .devenv/sources.sh\"" >> "$output_file"
    # echo "else" >> "$output_file"
    # echo "  echo \"Script '.devenv/sources.sh' already sourced.\"" >> "$output_file"
    # echo "  return 1" >> "$output_file"
    # echo "fi" >> "$output_file"
    echo "" >> "$output_file"

    local env_file="$PATH_DEVENV/.env/vars.sh"
    echo "[[ ! -f \"$env_file\" ]] || source \"$env_file\"" >> "$output_file"
    
	# Loop through each element in the array
	for element in "${list[@]}"; do
        local source_file="$HOME/$element/.output/sources.sh"
        echo "[[ ! -f \"$source_file\" ]] || source \"$source_file\"" >> "$output_file"
	done
}

first_run() {
    initialize
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
        "first-run")
            first_run
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