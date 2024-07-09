#!/bin/bash

PROMPT_COMMAND="set_ps"

repository_git_info() {
    declare -gA gitinfo=()
    local repo_name

    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return 1
    fi
    
    repo_path=$(git rev-parse --show-toplevel)
    repo_name=$(basename "$repo_path")

    local branch_name="$(git branch --show-current)"
    local ticket_no="$(echo "$branch_name" | awk -F/ '{print $NF}')"
    local count=$(echo "$ticket_no" | grep -o "-" | wc -l)

    if [ "$count" -gt 1 ]; then
        ticket_no="$(echo "$ticket_no" | awk -F- '{print $1"-"$2}')"
    fi

    gitinfo["repository"]="$repo_name"
    gitinfo["branch"]="$branch_name"
    gitinfo["ticket_no"]="$ticket_no"
    return 0
}

cleanup_repository_git_info() {
	unset gitinfo
}

set_ps1() {
	# echo "set_ps1()"
	repository_git_info	

	local is_repo=$?
	local PS1_txt=""
	local repository="${gitinfo["repository"]}"
	local branch="${gitinfo["branch"]}"
	local ticket_no="${gitinfo["ticket_no"]}"

	cleanup_repository_git_info

    # echo "Repository: ${gitinfo["repository"]}"
    # echo "Branch: ${gitinfo["branch"]}"
    # echo "Ticket No: ${gitinfo["ticket_no"]}"

	local color1='\[\e[38;5;69m\]'
	local color2='\[\e[38;5;76m\]'
	local color3='\[\e[38;5;213m\]'
	local reset_stye="\[\e[0m\]"

	PS1_txt='\u@\h:\w'
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		PS1_txt+=' ⚡ '
		PS1_txt+=$color3
		PS1_txt+=$branch
		PS1_txt+=$reset_stye
		PS1_txt+='\n'
		PS1_txt+=$color1
		# PS1_txt+="Repository: "
		PS1_txt+=$repository
		PS1_txt+=$reset_stye
		PS1_txt+='@'
		PS1_txt+=$color2
		# PS1_txt+="Ticket No: "
		PS1_txt+=$ticket_no
		PS1_txt+=$reset_stye
		# PS1_txt+='✨'
		PS1_txt+=$(get_random_emoji --ps)
		PS1_txt+=' '
	fi
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