#!/bin/bash

image_name="devenv-test"
dockerfile_path="docker"
curr_dir="$PWD"
echo "Current Directory: $curr_dir"

base_path=$(basename "$PWD")
dir_polskie_sh=".polskie.sh"

if [ "$base_path" = "$dir_polskie_sh" ]; then
    dockerfile_path=".symlinks/docker"
fi

cd "$dockerfile_path"
echo "Changed Directory: $PWD"

echo "RUN: docker build -t "$image_name-base" -f Dockerfile ."
docker build -t "$image_name-base" -f Dockerfile .

# if [ "$base_path" = "$dir_polskie_sh" ]; then
    # cd ../..
    # echo "Changed Directory: $PWD"
# fi

# echo "RUN: docker build -t "$image_name" -f Dockerfile-2 ."
# docker build -t "$image_name" -f Dockerfile-2 .
echo "RUN: docker build -t "$image_name" -f "Dockerfile-2" ."
docker build -t "$image_name" -f "Dockerfile-2" .

echo "RUN: docker run --rm "$image_name""
docker run --rm "$image_name"

cd "$curr_dir"
echo "Changed Directory: $PWD"


