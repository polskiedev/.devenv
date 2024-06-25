#!/bin/bash

source "$HOME/.devenv/common/functions/create_directories.sh" || echo "Failed to source '$HOME/.devenv/common/functions/create_directories.sh'"
source "$HOME/.devenv/common/functions/create_symlink.sh" || echo "Failed to source '$HOME/.devenv/common/functions/create_symlink.sh'"
source "$HOME/.devenv/common/functions/replace_home_path.sh" || echo "Failed to source '$HOME/.devenv/common/functions/replace_home_path.sh'"
