#!/bin/bash

psh() {
    source $(realpath "$HOME/.devenv.sources.sh")
    local command="$1"
    local config_file="commands.json"
    local json_file="$PATH_POLSKIE_SH/config/$config_file"

    local merged_json
    local tmp_file="$ENV_TMP_DIR/$ENV_TMP_SETTINGS/merged_commands.json"
    local tmp_file2="$ENV_TMP_DIR/$ENV_TMP_SETTINGS/merged_commands3.json"

    > "$tmp_file"

    json_file_processed=false
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local other_working_directory=$(git rev-parse --show-toplevel)
        local repo_name="$(basename "$other_working_directory")"
		other_working_directory+="/${ENV_THIRD_PARTY_WORKING_DIRECTORY}/config"

        local other_commands=""
        local other_commands1="$other_working_directory/$config_file"
        local other_commands2="$other_working_directory/$config_file/${repo_name}.json"
        local other_commands3="$other_working_directory/$config_file/repositories.json"
        local json_file_local="$PATH_POLSKIE_SH/.local/config/$config_file"

        jq_inputs=()

        [[ -f "$json_file" ]] && jq_inputs+=("$(cat "$json_file")") || echo "File '$json_file' not found. Skip merging commands."
        [[ -f "$other_commands1" ]] && jq_inputs+=("$(cat "$other_commands1")") || echo "File '$other_commands1' not found. Skip merging commands."
        [[ -f "$other_commands2" ]] && jq_inputs+=("$(cat "$other_commands2")") || echo "File '$other_commands2' not found. Skip merging commands."
        if [[ -f "$other_commands3" ]]; then
            local jq_input=""
            jq_input="{\"commands\": ["
            jq_input+=$(jq -r --arg item "$repo_name" '.commands[] | select(.repositories | index($item) != null) | @json' "$other_commands3" | paste -sd "," -)
            jq_input+="]}"
            jq_inputs+=("$jq_input")
        else
            echo "File '$other_commands3' not found. Skip merging commands."
        fi
        [[ -f "$json_file_local" ]] && jq_inputs+=("$(cat "$json_file_local")") || echo "File '$json_file_local' not found. Skip merging commands."

        # Merge JSON files if jq_inputs is not empty
        if [[ ${#jq_inputs[@]} -gt 0 ]]; then
            merged_json=$(jq -s 'reduce .[] as $item ({}; .commands += $item.commands)' <<< "${jq_inputs[@]}")

            echo "$merged_json" > "$tmp_file"
            echo "merged_commands: $tmp_file"
            json_file="$tmp_file"
        else
            echo "No JSON files to merge."
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