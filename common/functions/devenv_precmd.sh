#!/bin/bash

devenv_precmd() {
	local file=$(realpath "$HOME/.devenv.sources.sh")
    if [[ "$1" == "--common" ]]; then
        shift 
		file="$HOME/.devenv/common/sources.sh"
        # echo "Performing alternative command with args: $@"
    fi

	echo "Loading: $file"
	source "$file"
}