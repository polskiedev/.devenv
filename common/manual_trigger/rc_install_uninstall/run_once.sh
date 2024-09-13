#!/bin/bash

# script_dir="$HOME"
# script_name="helloworld.sh"
# lock_filename="${script_name}.lock"

# lock_file_dir="$script_dir"
# lock_filepath="$lock_file_dir/$lock_filename"

script_to_run_filepath="$1"
lock_filepath="$2"

# Extract directory and filename
directory=$(dirname "$script_to_run_filepath")
filename=$(basename "$script_to_run_filepath")

# echo "========================"
# echo "File: $lock_filepath"
# echo "Directory: $directory"
# echo "Filename: $filename"
# echo "========================"

prepare_dirs() {
    mkdir -p "$directory/lockfile"
    mkdir -p "$directory/runner"
}

prepare_dirs

if [[ -f "$script_to_run_filepath" && -z "$lock_filepath" ]]; then
    lock_filepath="${directory}/lockfile/${filename}.lock"
    # echo "Lock Path: $lock_filepath"
fi

run_once() {
    if [[ ! -f "$script_to_run_filepath" ]]; then
        echo "Error: Run Script is not a file"
        exit 1
    else
        bash "$script_to_run_filepath"
    fi
}

make_lockfile() {
    # Check if the script is already running by checking the lock file
    if [ -e "$lock_filepath" ]; then
        # Read the content of the lock file (should contain a number)
        lock_value=$(cat "$lock_filepath")
        # echo "Script is already running. Current lock value: $lock_value"
    else
        # echo "Hello World"
        # Initialize the lock file with a value of 1
        echo 0 > "$lock_filepath"
    fi
}

increment_lockfile_value() {
    # Increment the lock value if the lock file already exists
    if [ -e "$lock_filepath" ]; then
        lock_value=$(cat "$lock_filepath")
        # Increment the value
        new_value=$((lock_value + 1))
        echo "$new_value" > "$lock_filepath"
    fi
}

# Function to check if the lock file exists and its content is 0
check_lockfile() {
    if [ -e "$lock_filepath" ]; then
        lock_value=$(cat "$lock_filepath")
        if [ "$lock_value" -eq 0 ]; then
            return 0  # Return true
        else
            return 1  # Return false
        fi
    else
        return 1  # Return false if file doesn't exist
    fi
}

# Function to remove lock file on exit
cleanup() {
    rm -f "$lock_filepath"
}

if [[ ! -f "$script_to_run_filepath" ]]; then
    echo "Error: Run Script File Path cannot be empty"
    exit 1
fi

make_lockfile

# Example usage of the check_lockfile function
if check_lockfile; then
    run_once
    increment_lockfile_value
fi

# Create the lock file and ensure cleanup happens on script exit
# trap cleanup EXIT
