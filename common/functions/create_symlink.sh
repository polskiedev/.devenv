#!/bin/bash

create_symlink() {
    if [ $# -lt 2 ]; then
        echo "Error: At least two arguments are required: source_path and dest_path."
        return 1
    fi

    local source_path="$1"
    local dest_path="$2"

    echo "RUN: create_symlink('$source_path', '$dest_path')"
    # Check if the source exists
    if [ ! -e "$source_path" ]; then
        echo "Error: Source path '$source_path' does not exist."
    elif [ -f "$source_path" ]; then
        echo "Source path is a file."
    elif [ -d "$source_path" ]; then
        echo "Source path is a directory."
    else
        echo "Error: Source path '$source_path' is neither a file nor a directory."
        return 1
    fi

    # Check if the destination exists
    if [ -e "$dest_path" ]; then
        if [ -f "$dest_path" ]; then
            echo "Error: Destination path '$dest_path' already exists and is a file."
            return 1
        elif [ -d "$dest_path" ]; then
            echo "Error: Destination path '$dest_path' already exists and is a directory."
            return 1
        elif [ -L "$dest_path" ]; then
            echo "Error: Destination path '$dest_path' already exists and is a symlink."
            return 1
        else
            echo "Error: Destination path '$dest_path' exists but is neither a file, directory, nor symlink."
            return 1
        fi
    fi

    # Create the symlink
    ln -s "$source_path" "$dest_path"
    if [ $? -eq 0 ]; then
        echo "Symlink created: $dest_path -> $source_path"
    else
        echo "Error: Failed to create symlink."
        return 1
    fi
}

