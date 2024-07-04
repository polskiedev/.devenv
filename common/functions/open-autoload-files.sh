#!/bin/bash

open_autoload_files() {
	local list=("$HOME/.bashrc" "/etc/bash.bashrc" "$HOME/.zshrc")
	options=("${list[@]}")
	selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt="Open autoload file: ")

	if [ -n "$selected_option" ]; then
        # case "$selected_option" in
		# 	"option1") echo "option 1";;
        #   *) echo "Unknown command: $1" ;;
      	# esac
		psh_text_editor "$selected_option"
	fi
}