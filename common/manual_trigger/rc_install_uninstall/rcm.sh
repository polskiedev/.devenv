#!/bin/bash

# List of files to check
list=("$HOME/.bashrc" "/etc/bash.bashrc" "$HOME/.zshrc")

# Script content (e.g., a line that sources your script)
# script_dir="$HOME"
# script_filename="helloworld.sh"
# script_filepath="$script_dir/$script_line"
script_filepath="$2"

# Determine the directory where the script is located
this_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

script_run_once_filepath="$this_script_dir/run_once.sh"
script_runner_filepath="$this_script_dir/runner.sh"

# Function to display usage
usage() {
    echo "Usage: $0 {install|uninstall} {file path}"
}

preprocess_script() {
    # Extract directory and filename
    directory=$(dirname "$script_filepath")
    filename=$(basename "$script_filepath")

    echo "========================"
    echo "File: $script_filepath"
    echo "Directory: $directory"
    echo "Filename: $filename"
}

make_runner_script() {
    # Make runner file
    echo "#!/bin/bash" > "$script_runner_filepath"
    echo "bash \"$script_run_once_filepath\" \"$script_filepath\"" >> "$script_runner_filepath"
}

cleanup() {
    local lock_filepath="${script_filepath}.lock"
    if [[ -f "$lock_filepath" ]]; then
        rm -f "$lock_filepath"
    fi

    if [[ -f "$script_runner_filepath" ]]; then
        rm -f "$script_runner_filepath"
    fi
}

# Function to install the script
install_script() {
    preprocess_script
    make_runner_script
    for file in "${list[@]}"; do
        # Check if the file exists
        if [ -f "$file" ]; then
            # Check if the script is already installed
            if ! grep -Fxq "$script_line" "$file"; then
                echo "Installing to $file"
                echo "$script_line" >> "$file"
            else
                echo "Already installed in $file"
            fi
        else
            echo "$file does not exist"
        fi
    done
}

# Function to uninstall the script
uninstall_script() {
    preprocess_script
    process_runner
    cleanup
    for file in "${list[@]}"; do
        # Check if the file exists
        if [ -f "$file" ]; then
            # Check if the script is installed
            if grep -Fxq "$script_line" "$file"; then
                echo "Uninstalling from $file"
                # Remove the script line from the file
                sed -i "\|$script_line|d" "$file"
            else
                echo "Not installed in $file"
            fi
        else
            echo "$file does not exist"
        fi
    done
}

if [[ -z "$script_filepath" ]]; then
    echo "Error: File Path cannot be empty"
    usage
    exit 1
elif [[ ! -f "$script_filepath" ]]; then
    echo "Error: '$script_filepath' is not a valid file."
    usage
    exit 1
# else
#     echo "Processing package: '$script_filepath'"
fi

script_line="source $script_runner_filepath"
# script_line="source $script_filepath"

# Main switch-case block to handle install/uninstall commands
case "$1" in
    install|-i)
        install_script
        ;;
    uninstall|-u)
        uninstall_script
        ;;
    *)
        usage
        exit 1
        ;;
esac
