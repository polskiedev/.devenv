#!/bin/bash

source .env/vars.sh
source "$HOME/.devenv/common/sources.sh" #temp
# source $(realpath "$HOME/.devenv.sources.sh")

echo "Start: devenv_deploy"

bash "$PATH_POLSKIE_SH/setup.sh" make:file 

echo "Finish: devenv_deploy"