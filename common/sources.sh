#!/bin/bash

source "$HOME/.devenv/common/functions/create_directories.sh" || echo "Failed to source '$HOME/.devenv/common/functions/create_directories.sh'"
source "$HOME/.devenv/common/functions/create_symlink.sh" || echo "Failed to source '$HOME/.devenv/common/functions/create_symlink.sh'"
source "$HOME/.devenv/common/functions/extract_test_functions.sh" || echo "Failed to source '$HOME/.devenv/common/functions/extract_test_functions.sh'"
source "$HOME/.devenv/common/functions/precmd.sh" || echo "Failed to source '$HOME/.devenv/common/functions/precmd.sh'"
source "$HOME/.devenv/common/functions/process_args.sh" || echo "Failed to source '$HOME/.devenv/common/functions/process_args.sh'"
source "$HOME/.devenv/common/functions/psh.sh" || echo "Failed to source '$HOME/.devenv/common/functions/psh.sh'"
source "$HOME/.devenv/common/functions/replace_home_path.sh" || echo "Failed to source '$HOME/.devenv/common/functions/replace_home_path.sh'"
