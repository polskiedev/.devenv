#!/bin/bash

cd_back() {
  local levels="$1"
  if [ -z "$1" ]; then
    cd ..
    return 0
  fi

  # Check if a valid number is provided
  if [[ ! "$levels" =~ ^[0-9]+$ ]] || [[ "$levels" -eq 0 ]]; then
    echo "Please provide a valid positive number."
    return 1
  fi

  # Construct the path to go back N levels
  local path=""
  for ((i=0; i<levels; i++)); do
    path+="../"
  done

  # Change the directory
  cd "$path" || {
    echo "Failed to change directory."
    return 1
  }
}