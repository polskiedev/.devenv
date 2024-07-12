#!/bin/bash

spinner() {
    # local pid=$1
    local delay=0.1
    local spinstr='|/-\'

	local count_instance=${1:-1}
    local additional_chars=${2:-0}
	local format_instance="[c]"
	local format_str=""

    for (( h=0; h<$count_instance; h++ )); do
        format_str+="$format_instance"
    done

    local ctr=1
    # while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    while true; do
        
        if [ "$additional_chars" -gt 0 ] && [ "$ctr" -gt "$additional_chars" ]; then
            ctr=1
            # return
        fi

		local count_chars=0
		local print_params=()
        local temp=${spinstr#?}
        local spinstr=$temp${spinstr%"$temp"}

        # ################
        local backspace_str=""
        local count_backspace=$(echo -n "$format_str" | wc -m)
        local total_backspace=$((count_backspace + additional_chars))
        local format_str2=$(echo "$format_str" | sed 's/c/%c/g')

        for (( i=0; i<$total_backspace; i++ )); do
            backspace_str+="\b"
        done

        if [ "$additional_chars" -gt 0 ]; then
            # ################
            # Add dot
            
            for (( i=0; i<$ctr; i++ )); do
                format_str2+="."
            done
            # ################
            # Add space
            local space_str=" "
            local total_space=$((additional_chars - ctr))
            for (( i=0; i<$total_space; i++ )); do
                format_str2+=" "
            done
        fi
        # ################
        # Print spinner
        count_chars=$(echo "$format_str2" | grep -o '%c' | wc -l)

        for (( j=0; j<$count_chars; j++ )); do
          print_params+=("$spinstr")
        done

        # print_params+=("$(echo get_random_emoji)")
        printf "$format_str2" "${print_params[@]}"
        sleep $delay
        printf "$backspace_str"
        ((ctr++))
    done
}

# Function to display the progress bar
progressbar() {
  local progress=${1:-0}
  local max=${2:-100}
  local width=50
  local progress_width=$(( (progress * width) / max ))
  local remaining_width=$(( width - progress_width ))

  # Construct the progress bar
  local progress_bar=$(printf "%${progress_width}s" | tr ' ' '=')
  local remaining_bar=$(printf "%${remaining_width}s" | tr ' ' ' ')

  # Print the progress bar
  printf "\r[%s%s] %d%%" "$progress_bar" "$remaining_bar" "$(( (progress * 100) / max ))"
}

random_number() {
  local min=$1
  local max=$2

  # Calculate the random number
  local random_number=$((RANDOM % (max - min + 1) + min))
  echo $random_number
}

random_loading_indicator() {
  local min=1
  local max=2
  local random_num=$(random_number $min $max)
  local type="$random_num"

  if [ -n "$1" ]; then
    type="$1"
  fi

  case "$type" in
    "1")
      spinner 10 10
      ;;
    "2")
      local total=100
      for i in $(seq 0 $total); do
        progressbar $i $total
        sleep 0.1
      done
      echo ""
      ;;
    *)
      echo "Invalid parameter."
      return 1
      ;;
  esac
}
