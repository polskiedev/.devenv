#!/bin/bash

psh() {
    source $(realpath "$HOME/.devenv.sources.sh")
    local command="$1"
    local json_file="$PATH_POLSKIE_SH/config/commands.json"

    local real_command=$(jq -r --arg cmd "$command" '.commands[] | select(.command == $cmd) | .alias' "$json_file")
    local real_alt_command=$(jq -r --arg cmd "$command" '.commands[] | select(.alt_command == $cmd) | .alias' "$json_file")

    # Check if alias_command is not empty
    if [[ -n "$real_command" ]]; then
        # Execute the fetched command
        echo "Command: $real_command"
        shift
        eval "$real_command $@"
    elif [[ -n "$real_alt_command" ]]; then
        # Execute the fetched command
        echo "Alt Command: $real_alt_command"
        shift
        eval "$real_alt_command $@"
    elif [[ -z "$command" ]]; then
        cd "$HOME"
    else
        echo "Command '$command' not found in the JSON file"
    fi
}

psh_text_editor() {
    if [ -n "$1" ]; then
        nano "$1"
    else
        echo "File not passed."
    fi
}