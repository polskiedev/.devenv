#!/bin/bash

echo "Downloading '.devenv' repository..."

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

ls -al

echo "Installing '.devenv'..."