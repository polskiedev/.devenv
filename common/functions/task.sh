#!/bin/bash

MERGED_TASKS=""
TASKS_FILE1=".vscode/tasks.json"
TASKS_FILE2="$PATH_POLSKIE_SH/.vscode/tasks.json"
TASKS_FILE3=""

MERGE_FLAG=false
CUSTOM_FLAG=false

# Function to print script usage
print_usage() {
  echo "Usage: $0 [-m] [-o] [<task-file>]"
  echo "Options:"
  echo "  -m    Merge defaut tasks to list"
  echo "  -o    Show only custom tasks to list"
  echo "  <task-file>   Path to tasks JSON file (optional)"
}

if [ $# -gt 0 ]; then
	# Parse command line options
	while getopts ":mo" opt; do
		case ${opt} in
			m )
				MERGE_FLAG=true
				;;
			o )
				CUSTOM_FLAG=true
				;;
			\? )
				echo "Invalid option: $OPTARG" 1>&2
				print_usage
				exit 1
			;;
			: )
				echo "Invalid option: $OPTARG requires an argument" 1>&2
				print_usage
				exit 1
			;;
		esac
	done
	shift $((OPTIND -1))
fi

# Check if the specified task file exists
if [ ! -f "$TASKS_FILE1" ]; then
	echo "Error: Task file '$TASKS_FILE1' not found"
	exit 1
else
	# Read tasks from task1.json as base
	BASE_TASKS=$(jq -c '.tasks' "$TASKS_FILE1")
	MERGED_TASKS=$BASE_TASKS
fi

if [ "$MERGE_FLAG" = true ]; then
	# Check if the specified task file exists
	if [ ! -f "$TASKS_FILE2" ]; then
		echo "Error: Task file '$TASKS_FILE2' not found"
		exit 1
	fi

	# Merge tasks from task2.json without replacing existing tasks
	NEW_TASKS=$(jq -c '.tasks' "$TASKS_FILE2")

	# Merge base tasks and new tasks
	MERGED_TASKS=$(jq -n --argjson base "$MERGED_TASKS" --argjson new "$NEW_TASKS" '$base + $new')
fi

if [ "$CUSTOM_FLAG" = true ]; then
  	TASKS_FILE3="$1"
	# Check if the specified task file exists
	if [ ! -f "$TASKS_FILE3" ]; then
		echo "Error: Task file '$TASKS_FILE3' not found"
		exit 1
	fi

	CUSTOM_TASKS=$(jq -r '.tasks' "$TASKS_FILE3")
	if [ "$MERGE_FLAG" = true ]; then
		MERGED_TASKS=$(jq -n --argjson base "$MERGED_TASKS" --argjson new "$CUSTOM_TASKS" '$base + $new')
	else
		MERGED_TASKS=$CUSTOM_TASKS
	fi
fi

TASKS=$(echo "$MERGED_TASKS" | jq -r '.[].label')

# Pass the task list to fzf for selection
SELECTED_TASK=$(echo "$TASKS" | fzf --prompt="Select a task: ")

if [ -z "$SELECTED_TASK" ]; then
  echo "No task selected."
  exit 1
fi

echo "Selected task: $SELECTED_TASK"

# Find the selected task details
TASK_DETAILS=$(echo "$MERGED_TASKS" | jq -r ".[] | select(.label == \"$SELECTED_TASK\")")
TASK_COMMAND=$(echo "$TASK_DETAILS" | jq -r ".command")
TASK_ARGS=$(echo "$TASK_DETAILS" | jq -r ".args")

# Validate if TASK_ARGS is not empty and not an empty array
if [ -n "$TASK_ARGS" ] && [ "$(echo "$TASK_ARGS" | jq 'length')" -ne 0 ]; then
	ARGS_STRING=$(echo "$TASK_ARGS" | jq -r '.[]' | tr '\n' ' ')
  	TASK_EXECUTE="$TASK_COMMAND $ARGS_STRING"
else
  TASK_EXECUTE="$TASK_COMMAND"
fi

echo $TASK_EXECUTE
# Save the selected task details to a temporary file
# TEMP_TASK_DETAILS_FILE=$(mktemp --suffix=.json)

