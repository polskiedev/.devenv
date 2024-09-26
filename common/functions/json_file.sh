#!/bin/bash

# Todo: Transfer as a test file
test_json() {
    declare -A json_result
    json_result["name"]="John Smith"
    json_result["email"]="johnsmith@test.com"
    json_result["birthday"]="12-01-1988"

    local file="$PATH_POLSKIE_SH/.temp/sample.json"
    local tmpfile="$PATH_POLSKIE_SH/.temp/tmp_sample.json"
    ###########################
    echo "Checking json file creation..."
	make_json_file json_result --file:"$file" --tmpfile:"$tmpfile"

    for key in "${!json_result[@]}"; do
        local value="${json_result[$key]}"
        echo "1. $key: $value"
    done
    # ###########################
    echo "Checking get data from json file..."
    declare -A json_result2
    get_json_data json_result2 --file:"$file"
    for key2 in "${!json_result2[@]}"; do
        local value2="${json_result2[$key2]}"
        echo "2: $key2: $value2"
    done
    ###########################
    echo "Checking modified data both add and edit..."
    modify_json_data --file:"$file" --tmpfile:"$tmpfile" --jsonkey:"address" --jsonvalue:"Somewhere around the earth" --showdata
    modify_json_data --file:"$file" --tmpfile:"$tmpfile" --jsonkey:"name" --jsonvalue:"Jane Doe" --showdata
   
    echo "JSON file contents:"
    cat "$file"
}

make_json_file() {
    local -n json_data=$1
    shift
    # ########################################################################
    declare -A result
    declare -a remaining_parameters
    local requested_vars=("showdata" "file" "tmpfile")
    local args=("$@")

    process_args result remaining_parameters requested_vars[@] "${args[@]}"

    count=${#remaining_parameters[@]}

    if [[ "${result["showdata"]}" = true ]]; then
        IFS=','; joined_string="${args[*]}"; unset IFS
        echo "Passed Arguments: ($joined_string)"

        echo "Request Parameters:"
        for key in "${!result[@]}"; do
            echo "$key: ${result[$key]}"
        done

        echo "Remaining Parameters:"
        for param in "${remaining_parameters[@]}"; do
            echo "$param"
        done
    fi
    # ########################################################################
    # Process
    # ########################################################################
	local file="${result["file"]}"
    local tmpfile="${result["tmpfile"]}"

    echo "Processing json file: '$file'"
	if [ ! -f "$file" ]; then
        echo "Creating json file: '$file'"
		echo '{}' > "$file"
		# Process json file creation
		local jq_command_list=()
		local jq_command_str
		local jq_command="jq"
		local jq_command2="'{"

		for key in "${!json_data[@]}"; do
			value=${json_data[$key]}
			# echo "$key: $value"
			jq_command+=" --arg $key \"$value\" [newline]"
			jq_command_list+=("\"$key\": \$$key")
		done

		jq_command_str=$(IFS=,; echo "${jq_command_list[*]}")
		jq_command_str="${jq_command_str//,/, }"

		jq_command2+=$jq_command_str
		jq_command2+="}' [newline]"

		jq_command+=" $jq_command2"
		jq_command+=" \"$file\" [newline]> \"$tmpfile\" [newline]"
		jq_command+=" && mv \"$tmpfile\" \"$file\""

		jq_command="$(echo $jq_command | sed -e 's/\[newline\]/\\'\\n'/g')"

		# echo "jq_command: $jq_command"
		eval "$jq_command"
        echo "JSON file contents:"
        cat "$file"
    else
        echo "Cannot create json file. File '$file' already exists."
        echo "Skipping process..." # && rm "$file"
	fi
}

modify_json_data() {
    # ########################################################################
    declare -A result
    declare -a remaining_parameters
    local requested_vars=("showdata" "file" "tmpfile" "jsonkey" "jsonvalue")
    local args=("$@")

    process_args result remaining_parameters requested_vars[@] "${args[@]}"

    count=${#remaining_parameters[@]}

    if [[ "${result["showdata"]}" = true ]]; then
        IFS=','; joined_string="${args[*]}"; unset IFS
        echo "Passed Arguments: ($joined_string)"

        echo "Request Parameters:"
        for key2 in "${!result[@]}"; do
            echo "$key2: ${result[$key2]}"
        done

        echo "Remaining Parameters:"
        for param in "${remaining_parameters[@]}"; do
            echo "$param"
        done
    fi
    # ########################################################################
    # Process
    # ########################################################################
	local file="${result["file"]}"
    local tmpfile="${result["tmpfile"]}"
	local json_key="${result["jsonkey"]}"
    local json_value="${result["jsonvalue"]}"

    declare -A json_result2
    get_json_data json_result2 --file:"$file"

    local jq_command="jq"
    if [ -v 'json_result2[$json_key]' ]; then
        echo "Search Key '$json_key' have a value of '${json_result2[$json_key]}'"
        # jq '. + {address: "123 Main St"} | .email = "johnsmith@newdomain.com"' "$json_file" > tmp.$$.json && mv tmp.$$.json "$json_file"
        jq_command+=" '. + {$json_key: \"$json_value\"}'"
    else
        echo "Search Key '$json_key' not found!"
        jq_command+=" '.$json_key = \"$json_value\"'"
    fi

	jq_command+=" \"$file\" > \"$tmpfile\""
    jq_command+=" && mv \"$tmpfile\" \"$file\""

    # echo "jq_command: $jq_command"
    eval "$jq_command"
}

get_json_data() {
    local -n json_data=$1
    shift
    # ########################################################################
    declare -A result
    declare -a remaining_parameters
    local requested_vars=("showdata" "file")
    local args=("$@")

    process_args result remaining_parameters requested_vars[@] "${args[@]}"

    count=${#remaining_parameters[@]}

    if [[ "${result["showdata"]}" = true ]]; then
        IFS=','; joined_string="${args[*]}"; unset IFS
        echo "Passed Arguments: ($joined_string)"

        echo "Request Parameters:"
        for key in "${!result[@]}"; do
            echo "$key: ${result[$key]}"
        done

        echo "Remaining Parameters:"
        for param in "${remaining_parameters[@]}"; do
            echo "$param"
        done
    fi
    # ########################################################################
    # Process
    # ########################################################################
	local file="${result["file"]}"

	if [ -f "$file" ]; then
         echo "Processing file: '$file'"
		compressed_output=$(jq -c '.' "$file")
		jq_output=$(echo "$compressed_output" | jq -r 'to_entries[] | "\(.key) \(.value)"')
	
		# Read compressed JSON output line by line
		while IFS= read -r line; do
			key=$(echo "$line" | awk '{print $1}')
			value=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
			json_data["$key"]=$value
		done <<< "$jq_output"
    else
        echo "File not found: '$file'"
    fi
}

merge_json_file() {
    echo "merge_json_file()"
    echo "This is a test function for now"
    return
    local working_directory="$PATH_POLSKIE_SH/.temp/merge_json"
    local file1="$working_directory/file1.json"
    local file2="$working_directory/file2.json"
    local tmp_file="$working_directory/temp.json"

    json1=$(<"$file1")
    json2=$(<"$file2")

    merged_json=$(jq -s '.[0].commands + .[1].commands | {commands: .}' <(echo "$json1") <(echo "$json2"))
    echo "$merged_json"
}

merge_vscode_tasks_json_files() {
    output_file="$1"
    shift  # Shift to get the remaining parameters (directories/files)

    input_files=()

    # Loop through the remaining arguments (directories or files)
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            # If it's a directory, include all .json files in that directory
            for json_file in "$arg"/*.json; do
                # Only include if it actually matches .json files
                if [ -f "$json_file" ]; then
                    input_files+=("$json_file")
                    echo "Merging file: '$json_file'"
                fi
            done
        elif [ -f "$arg" ] && [[ "$arg" == *.json ]]; then
            # If it's a .json file, include it
            input_files+=("$arg")
            echo "Merging file: '$arg'"
        fi
    done

    # Check if we have at least two JSON files to merge
    if [ ${#input_files[@]} -lt 2 ]; then
        echo "You must have at least two JSON files to merge."
        return 1
    fi

    # Merge the "tasks" and "inputs" arrays, handling missing keys
    merged_content=$(jq -s '
        {
            version: .[0].version,
            tasks: (map(.tasks // [] | map(select(.enabled != false) | del(.enabled))) | add),
            inputs: (map(.inputs // []) | add)
        }
    ' "${input_files[@]}")

    if [ $? -eq 0 ]; then
        echo "$merged_content" > "$output_file"
        echo "Merged JSON files into: $output_file"
    else
        echo "Error: Failed to merge JSON files."
        return 1
    fi
}
