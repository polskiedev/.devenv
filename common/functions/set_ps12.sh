#!/bin/bash

ps1_repo_name() {
	local repo_name
	local msg=""
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        repo_path=$(git rev-parse --show-toplevel)
        repo_name=$(basename "$repo_path")
		branch_name="$(git branch --show-current)"

        msg="$repo_name"
    fi
	echo "$msg"
}

ps1_repo_branch_name() {
	branch_name="$(git branch --show-current)"
	echo "$branch_name"
}

set_ps1() {
	echo "set_ps1()"
	ENV_DEFAULT_PS1="$PS1"
	# ENV_DEFAULT_PS2="$PS2"

	local color1='\[\e[38;5;69m\]'
	local color2='\[\e[38;5;76m\]'
	local reset_stye="\[\e[0m\]"
	local PS1_txt='\u@\h:\w'

	PS1_txt+="$(if [ $(ps1_repo_name) ]; then \
		echo ""; \
		echo -n "${color1}$(ps1_repo_name)${reset_stye}@${color2}$(ps1_repo_branch_name)${reset_stye}"; fi)"
	PS1_txt+='\$ ' 

	PS1="$PS1_txt"
}

set_ps() {
	set_ps1
}

add_default_setting_override_ps12() {
	# It seems this function is not needed anymore, just assign to
	# global variable
	echo "add_default_setting_override_ps12()"

	local type="settings"
	local settings_dir="$ENV_TMP_DIR/$ENV_TMP_SETTINGS"
	local file1="default.ps1.txt"
	local file2="default.ps2.txt"

	add_to_temp "$type" "${file1}" "$PS1"
	add_to_temp "$type" "${file2}" "$PS2"
}