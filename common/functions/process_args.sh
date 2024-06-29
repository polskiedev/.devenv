#!/bin/bash
process_args() {
    local -n request_vars=$1
    local -n remaining_parameters_ref=$2
    local requested_vars=("${!3}")
    shift 3
    local args=("$@")

    # Initialize the associative array for request parameters
    for var in "${requested_vars[@]}"; do
        request_vars["$var"]=""
    done

    for arg in "${args[@]}"; do
        if [[ "$arg" =~ ^--?([^:=]+)[:=](.+)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"

            if in_array "$key" "${requested_vars[@]}"; then
                request_vars["$key"]="$value"
            else
                remaining_parameters_ref+=("$arg")
            fi
        else
            remaining_parameters_ref+=("$arg")
        fi
    done
}