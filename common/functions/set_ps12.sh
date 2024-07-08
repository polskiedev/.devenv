#!/bin/bash

PROMPT_COMMAND="set_ps"

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
	local branch_name="$(git branch --show-current)"
	local ticket_no="$(echo "$branch_name" | awk -F/ '{print $NF}')"
	local count=$(echo "$ticket_no" | grep -o "-" | wc -l)

	if [ "$count" -gt 2 ]; then
		ticket_no="$(echo "$ticket_no" | awk -F- '{print $1"-"$2}')"
	fi
	echo "$ticket_no"
}

set_ps1() {
	# echo "set_ps1()"

	local color1='\[\e[38;5;69m\]'
	local color2='\[\e[38;5;76m\]'
	local reset_stye="\[\e[0m\]"
	local PS1_txt='\u@\h:\w'

	PS1_txt+='\n'
	PS1_txt+='\[\e[38;5;69m\]$(ps1_repo_name)\[\e[0m\]@\[\e[38;5;76m\]$(ps1_repo_branch_name)\[\e[0m\]'
	PS1_txt+='✨'
	PS1_txt+='\$ '

	PS1="$PS1_txt"
}

set_ps() {
	# echo "set_ps()"
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