#!/bin/bash

psh() {
    source $(realpath "$HOME/.devenv.sources.sh")
    local command="$1"
    local json_file="$PATH_POLSKIE_SH/config/commands.json"

    local merged_json
    local tmp_file="$ENV_TMP_DIR/$ENV_TMP_SETTINGS/merged_commands.json"
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local other_working_directory=$(git rev-parse --show-toplevel)
		other_working_directory+="/${ENV_THIRD_PARTY_WORKING_DIRECTORY}/config"

        local other_commands="$other_working_directory/commands.json"
        # echo "other_command: $other_command"
        
        if [ -f "$other_commands" ]; then
            json1=$(<"$json_file")
            json2=$(<"$other_commands")
            merged_json=$(jq -s '.[0].commands + .[1].commands | {commands: .}' <(echo "$json1") <(echo "$json2"))
            
            echo "$merged_json" > "$tmp_file"
            echo "merged_commands: $tmp_file"
            json_file="$tmp_file"
        else
            echo "File '$other_commands' not found. Skip merging commands."
        fi
	fi

    local real_command=$(jq -r --arg cmd "$command" '.commands[] | select(.command == $cmd) | .alias' "$json_file")
    local real_alt_command=$(jq -r --arg cmd "$command" '.commands[] | select(.alt_command == $cmd) | .alias' "$json_file")
    # local real_command=$(echo "$merged_json" | jq -r --arg cmd "$command" '.commands[] | select(.command == $cmd) | .alias')
    # local real_alt_command=$(echo "$merged_json" | jq -r --arg cmd "$command" '.commands[] | select(.alt_command == $cmd) | .alias')

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