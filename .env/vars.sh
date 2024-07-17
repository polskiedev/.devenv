#!/bin/bash

export PATH_DEVENV="$HOME/.devenv"
# export PATH_DEVENV="$(dirname "$(readlink -f "$0")")"
export ENV_VERBOSE_LOGS=1
export ENV_TMP_DIR="$PATH_DEVENV/.temp"
export ENV_TMP_CACHE=".cache"
export ENV_TMP_LIST=".list"
export ENV_TMP_STATE=".state"
export ENV_TMP_PREVIOUS_STATE=".state.previous"
export ENV_TMP_HISTORY=".history"
export ENV_TMP_OTHERS=".others"
export ENV_TMP_SETTINGS=".settings"
export ENV_TMP_TODO_READ_DIR=".todo/.read"
export ENV_TMP_TODO_REFERENCE=".reference"
export ENV_TMP_WORKER_TASKS=".worker_tasks"
export ENV_TMP_SYMLINK="$HOME/.tmp"

export ENV_THIRD_PARTY_WORKING_DIRECTORY=".polskie.sh"
export ENV_TEST_MESSAGE="Message is not yet overridden"