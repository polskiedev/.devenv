#!/bin/bash

# Todo: Not working properly when docker starts?
devenv_test_branch="DEV-000003-setup"
home_dir="/root/ubuntu"

echo "Downloading '.devenv' repository..."

echo "Current Directory: $PWD"

# Check if Git is installed and get its version
if git --version &> /dev/null; then
    echo "Git is installed. Version: $(git --version)"
else
    echo "Git is not installed."
fi

git clone https://github.com/polskiedev/.devenv.git

# Check the exit status of the git clone command
if [ $? -eq 0 ]; then
    echo "Git repository cloned successfully."
else
    echo "Failed to clone Git repository."
fi

chmod 755 .devenv

echo "$PWD"

ls -al

echo "Installing '.devenv'..."

cd .devenv

git checkout "$devenv_test_branch"

