#!/bin/bash

get_datetime() {
	local datetime_format="%Y-%m-%d %H:%M:%S"
	local timestamp=$(date +"$datetime_format")
	local date_args=()

    declare -A result
    declare -a remaining_parameters
    local requested_vars=("days")
    local args=("$@")

    process_args result remaining_parameters requested_vars[@] "${args[@]}"
	if [[ "${result["days"]}" != false ]]; then
		date_args+=("-d" "${result["days"]} days")
	fi

	if [[ -n "$1" ]]; then
		case "$1" in
			"--human") datetime_format="%Y-%m-%d_%I%M%p" ;;
			"--date") datetime_format="%Y-%m-%d" ;;
			"--backup") datetime_format="%Y%m%d_%I%M%p" ;;
			"--pretty") datetime_format="%a, %d %b '%y @ %I:%M%p" ;;
			"--pretty-compressed") datetime_format="%a,%d%b'%y@%I:%M%p" ;;
			"--pretty-with-icon") datetime_format="📆 %a, %d %b '%y 🧭 %I:%M%p" ;;
		esac

		case "$1" in
			"--human" | "--date" | "--pretty" | "--pretty-with-icon" | "--pretty-compressed")
				date_args+=("+$datetime_format")
				timestamp=$(date "${date_args[@]}")
				;;
			"--backup")
				date_args+=(+"$datetime_format")

				timestamp=$(date "${date_args[@]}")
				timestamp=$(echo $timestamp | sed 's/AM/am/' | sed 's/PM/pm/')
				;;
			*)
				echo "Invalid parameter for get_datetime()"
				return 1
				;;
		esac
	fi

	echo "$timestamp"
}