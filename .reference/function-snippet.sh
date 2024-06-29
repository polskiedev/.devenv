#!/bin/bash

# Function to handle parameters
my_func() {
    # Default values
    file_action=""
    file_name=""

    # Parse parameters
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -file:*)
                file_action="${1#-file:}"
                ;;
            -name:*)
                file_name="${1#-name:}"
                ;;
            *)
                echo "Unknown parameter: $1"
                return 1
                ;;
        esac
        shift
    done

    # Perform actions based on parsed parameters
    echo "File action: $file_action"
    echo "File name: $file_name"

    # Add your logic here
    if [[ "$file_action" == "add" ]]; then
        echo "Adding file: $file_name"
        # Example: touch "$file_name"
    fi
}

# Example usage
my_func -file:add -name:test.txt
