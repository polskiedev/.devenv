#!/bin/bash

replace_home_path () {
    # local input_path="$1"
    echo "${1/#$HOME/\$HOME}"

    # Check if the first part of the path is equal to $HOME
    # if [[ "$input_path" == $HOME/* ]]; then
        # Return the path as it is if it starts with $HOME
        # echo "\$HOME/$input_path"
    # else
    #     echo "$input_path"
    # fi
}