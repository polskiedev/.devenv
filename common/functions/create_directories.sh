#!/bin/bash

create_directories() {
    local dir_path="$1"
    echo "create_directories()"
    echo "Processing: '$dir_path'"

    if [ -z "$dir_path" ]; then
        echo "Error: Directory path is required."
        return 1
    fi

    if [ -d "$dir_path" ]; then
        echo "Directory '$dir_path' already exists."
    else
        mkdir -p "$dir_path"
        if [ $? -eq 0 ]; then
            echo "Directory '$dir_path' created successfully."
        else
            echo "Error: Failed to create directory '$dir_path'."
            return 1
        fi
    fi
}