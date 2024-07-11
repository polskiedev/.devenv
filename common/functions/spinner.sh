#!/bin/bash

spinner() {
    # local pid=$1
    local delay=0.1
    local spinstr='|/-\'

	local count_instance=${1:-1}
	local count_backspace=0
	local backspace_str=""
	local format_instance="[c]"
	local format_str=""

    for (( h=0; h<$count_instance; h++ )); do
        format_str+="$format_instance"
    done

    count_backspace=$(echo -n "$format_str" | wc -m)
    for (( i=0; i<$count_backspace; i++ )); do
        backspace_str+="\b"
    done

	format_str=$(echo "$format_str" | sed 's/c/%c/g')

    # while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    while true; do
		local count_chars=0
		local print_params=()
        local temp=${spinstr#?}
        local spinstr=$temp${spinstr%"$temp"}
		
		count_chars=$(echo "$format_str" | grep -o '%c' | wc -l)
		for (( j=0; j<$count_chars; j++ )); do
			print_params+=("$spinstr")
		done

        printf "$format_str" "${print_params[@]}"
        sleep $delay
        printf "$backspace_str"
    done
    printf "$backspace_str"
}