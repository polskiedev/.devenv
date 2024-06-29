#!/bin/bash
psh() {
    source $(realpath "$HOME/.devenv.sources.sh")
    local command="$1"
    local json_file="$PATH_POLSKIE_SH/config/commands.json"

    local real_command=$(jq -r --arg cmd "$command" '.commands[] | select(.command == $cmd) | .alias' "$json_file")

    # Check if alias_command is not empty
    if [[ -n "$real_command" ]]; then
        # Execute the fetched command
        echo "Command: $real_command"
        shift
        eval "$real_command $@"
    else
        echo "Command not found in the JSON file"
    fi
}