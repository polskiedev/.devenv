#!/bin/bash

# Author: Polskie
# Description: Set custom prompts for devs

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

	# Check for modified files
	local modified_count=$(git diff --name-only | wc -l)

	# Check for staged files
	local staged_count=$(git diff --cached --name-only | wc -l)

	# Check for untracked files
	local untracked_count=$(git ls-files --others --exclude-standard | wc -l)

	# Combine all results
	local changes="${modified_or_staged}${staged}${untracked}"

	# Total changes
	local total_changes=$((modified_count + staged_count + untracked_count))
	local changes_text="✔️"

	gitinfo["total_changes"]=""

	# Check if there are any changes
	if [[ $total_changes -gt 0 ]]; then
		changes_text="{📝:${modified_count},🧩:${staged_count},🤷:${untracked_count}}"
		gitinfo["total_changes"]="$total_changes"
	fi

	gitinfo["changes_text"]="$changes_text"
	
    gitinfo["repository"]="$repo_name"
    gitinfo["branch"]="$branch_name"
    gitinfo["ticket_no"]="$ticket_no"
    return 0
}

cleanup_repository_git_info() {
	unset gitinfo
}

get_random_emoji_ps1() {
    if type "get_random_emoji" 2>/dev/null | grep -q 'function'; then
		echo $(get_random_emoji --ps)
		return 0
    fi

	local emojis=()
	# local list_emoji="📂📝📆📦💻💾⭐⚡🚀"
	local list_emoji="😄😃😀😍😘😚😗😜😝😙😛😳😊😁😂😅😆😋😷😎😇🥰"

	# Use grep to match each emoji and store in the array
	while IFS= read -r -n1 char; do
		# Append the character to the array
		emojis+=("$char")
	done <<< "$list_emoji"

    local random_index=$(( RANDOM % ${#emojis[@]} ))
    emoji="${emojis[$random_index]}"

	echo "emoji"
}

set_ps1() {
	# echo "set_ps1()"
	repository_git_info	

	local is_repo=$?
	local PS1_txt=""
	local repository="${gitinfo["repository"]}"
	local branch="${gitinfo["branch"]}"
	local ticket_no="${gitinfo["ticket_no"]}"
	local total_changes="${gitinfo["total_changes"]}"
	local changes_text="${gitinfo["changes_text"]}"

	cleanup_repository_git_info

    # echo "Repository: ${gitinfo["repository"]}"
    # echo "Branch: ${gitinfo["branch"]}"
    # echo "Ticket No: ${gitinfo["ticket_no"]}"
	local date_time_text=$(date +"%Y-%m-%d %H:%M:%S")
    if type "get_datetime" 2>/dev/null | grep -q 'function'; then
		date_time_text=" $(get_datetime --pretty-with-icon)"
    fi
	# ######################################
	# Colors here
	# ######################################
	
	local color1='\[\e[38;5;69m\]'
	local color2='\[\e[38;5;76m\]'
	local color3='\[\e[38;5;213m\]'
	local reset_style="\[\e[0m\]"
	# Define separators and edges
	local LEFT_EDGE=""
	local RIGHT_EDGE=""
	local SEPARATOR=">"

	local PS1_txt_default='\u@\h:\w\$ '
	PS1_txt="$PS1_txt_default"

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		# PS1_txt+=$FG_BLUE
		# PS1_txt+=$LEFT_EDGE
		# PS1_txt+=$reset_style
		# ##################
		PS1_txt=''
		PS1_txt+='👷 '
		PS1_txt+='\u'
		PS1_txt+=' 💻 '
		PS1_txt+='\h'
		PS1_txt+=$date_time_text
		PS1_txt+='\n'
		PS1_txt+='📂 '
		PS1_txt+='\w'
		PS1_txt+=' 🌱 '
		PS1_txt+=$color3
		PS1_txt+=$branch
		PS1_txt+=$reset_style

		# ##################
		if [ -n "${changes_text}" ]; then
			PS1_txt+=" ${changes_text}"
		fi

		# ##################
		# PS1_txt+=$FG_BLUE
		# PS1_txt+=$RIGHT_EDGE
		# PS1_txt+=$reset_style
		# ###############################

		PS1_txt+='\n'
		PS1_txt+=$reset_style
		# PS1_txt+='⏵'
		PS1_txt+=$color1
		# PS1_txt+="Repository: "
		PS1_txt+='📦 '
		PS1_txt+=$repository
		PS1_txt+=$reset_style
		# PS1_txt+=' ⭐ '
		# PS1_txt+='⏵'
		PS1_txt+=$color2
		# PS1_txt+="Ticket No: "
		PS1_txt+=' 🏷️  '
		PS1_txt+=$ticket_no
		PS1_txt+=$reset_style
		# PS1_txt+='✨'
		PS1_txt+=' ⏵ '
		PS1_txt+=$(get_random_emoji_ps1)
		PS1_txt+=' '
		PS1_txt+='\$⏵ '
		PS1_txt+=$reset_style
	fi

	if [[ "$HOME" == "$PWD" ]]; then
		PS1_txt='\u@\h:\w\$🏠: '
	fi

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